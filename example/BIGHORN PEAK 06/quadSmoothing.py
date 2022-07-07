# -*- coding: utf-8 -*-
"""
Created on Mon May 21 06:59:51 2018

@author: Silvio.Baldino
"""

from math import pi

import numpy as np
from cvxopt import blas, lapack, solvers
from cvxopt import matrix, spmatrix, sin, mul, div, normal
solvers.options['show_progress'] = 0


def quadSmoothing(pGR):
    """
    Algorithm that perform the quadratic smoothing on the input log. 
    Reference: Convex Optimization by Stephen Boyd
    Input:
        pGR Gamma Ray Log (numpy array)
    Return: Smoothed Gamma Ray Log
    """
    corr=matrix(pGR)
    n=np.shape(corr)[0]
    
    # Quadratic smoothing.
    # A = D'*D is an n by n tridiagonal matrix with -1.0 on the
    # upper/lower diagonal and 1, 2, 2, ..., 2, 2, 1 on the diagonal.
    Ad = matrix([1.0] + (n-2)*[2.0] + [1.0])
    As = matrix(-1.0, (n-1,1))
    
    nopts = 100
    deltas = -10.0 + 20.0/(nopts-1) * matrix(list(range(nopts)))
#    print(deltas)
    cost1, cost2 = [], []
    for delta in deltas:
        xr = +corr
        lapack.ptsv(1.0 + 10**delta * Ad, 10**delta * As, xr)
        cost1 += [blas.nrm2(xr - corr)]
        cost2 += [blas.nrm2(xr[1:] - xr[:-1])]

    # compute knee point / intersection of the 2 lines
    Xa=cost1[3]
    Xb=cost1[0]
    Ya=cost2[3]
    Yb=cost2[0]
    a1 = 1.0*(Ya-Yb)/(Xa-Xb+1e-6)
    b1 = Ya - a1* Xa
    
    Xc=cost1[-4]
    Xd=cost1[-1]
    Yc=cost2[-4]
    Yd=cost2[-1]
    a2 = 1.0*(Yc-Yd)/(Xc-Xd+1e-6)
    b2 = Yc - a2* Xc
    
    Xintersect = (b2 -b1)/(a1-a2+1e-6)
    Yintersect = a1*Xintersect +b1
    
    npcost1 = np.array(cost1, dtype=np.float32)
    npcost2 = np.array(cost2, dtype=np.float32)
    distance2IntersectPoint = (npcost1-Xintersect)**2 + (npcost2-Yintersect)**2 
    idx = np.argmin(distance2IntersectPoint)
    
    # Find solutions with ||xhat - xcorr || roughly equal to knee point.
    mv1, k1 = min(zip([abs(c - npcost1[idx]) for c in cost1], range(nopts)))
    xr1 = +corr
    lapack.ptsv(1.0 + 10**deltas[k1] * Ad, 10**deltas[k1] * As, xr1)
    
    xn1 = np.array(xr1)
    
    return xn1.flatten()

def despike_log(pStandGr, pFactor, pAlpha):
    """
    Despike Log by removing a given percentage of outliers as well as combining the 
    raw data with a smoothed version of it 
    Input:
        pStandGr Gamma Ray Log (numpy array)
        pFactor Standard deviation factor of outliers [ex. =2.0 if 4.6% outliers]
        pAlpha  Ratio of smoothness desired for final output [0 1]
    Return:
        pStandGr Filtered Gamma Ray Log
    """
    xsmooth = quadSmoothing(pStandGr)
    diff_gr = pStandGr - xsmooth
    standStd  = np.std(diff_gr)
    standMean = np.mean(diff_gr)
    prevGR = xsmooth[0]
    for ii in range(len(pStandGr)):
        if abs(diff_gr[ii]-standMean)>= pFactor * standStd:
            pStandGr[ii]=prevGR
        else:
            # pick weight of smooth vs raw data
            prevGR = pAlpha*pStandGr[ii]+ (1.0-pAlpha) * xsmooth[ii]
            pStandGr[ii] = prevGR
    return pStandGr

def smooth2(y, box_pts):
    box = np.ones(box_pts)/box_pts
    y_smooth = np.convolve(y, box, mode='same')
    return y_smooth

