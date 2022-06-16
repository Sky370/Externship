# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

from dash import Dash
import dash_html_components as html
import dash_core_components as dcc
import plotly.express as px
import pandas as pd

app = Dash(__name__)

# assume you have a "long-form" data frame
# see https://plotly.com/python/px-arguments/ for more options
df = pd.DataFrame({
    "Fruit": ["Apples", "Oranges", "Bananas", "Apples", "Oranges", "Bananas"],
    "Amount": [4, 1, 2, 2, 4, 5],
    "City": ["SF", "SF", "SF", "Montreal", "Montreal", "Montreal"]
})

fig = px.bar(df, x="Fruit", y="Amount", color="City", barmode="group")

app.layout = html.Div(children=[
    html.H1(children='Hello Dash'),

    html.Div(children='''
        Dash: A web application framework for your data.
    '''),

    dcc.Graph(
        id='example-graph',
        figure=fig
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)


# ***************************
theme = {
   "accent":"#75C9BE",
   "accent_negative":"#ff2c6d",
   "accent_positive":"#33ffe6",
   "background_content":"#153F4C",
   "background_page":"#1F5869",
   "border":"#63A8A6",
   "breakpoint_font":"1200px",
   "breakpoint_stack_blocks":"700px",
   "card_border":{
       "width":"0px",
       "style":"solid",
       "color":"#63A8A6",
       "radius":"0px"
   },
   "card_background_color":"#153F4C",
   "card_box_shadow":"0px 1px 3px rgba(0,0,0,0.12), 0px 1px 2px rgba(0,0,0,0.24)",
   "card_margin":"15px",
   "card_padding":"5px",
   "card_outline":{
       "width":"0px",
       "style":"solid",
       "color":"#63A8A6"
   },
   "card_header_border":{
       "width":"0px",
       "style":"solid",
       "color":"#63A8A6",
       "radius":"0px"
   },
   "card_header_background_color":"#153F4C",
   "card_header_box_shadow":"0px 0px 0px rgba(0,0,0,0)",
   "card_header_margin":"0px",
   "card_header_padding":"10px",
   "colorway":[
       "#75c9be",
       "#ffffb3",
       "#bebada",
       "#fb8072",
       "#80b1d3",
       "#fdb462",
       "#b3de69",
       "#fccde5",
       "#d9d9d9",
       "#bc80bd",
       "#ccebc5",
       "#ffed6f"
   ],
   "colorscale":[
       "#75c9be",
       "#86cfc5",
       "#96d5cc",
       "#a6dbd3",
       "#b5e1da",
       "#c4e7e2",
       "#d3ede9",
       "#e2f3f0",
       "#f0f9f8",
       "#ffffff"
   ],
   "font_family":"Open Sans",
   "font_size":"15px",
   "font_size_smaller_screen":"13px",
   "font_family_header":"Noto Serif",
   "font_size_header":"24px",
   "font_family_headings":"Noto Serif",
   "font_headings_size":None,
   "header_border":{
       "width":"0px",
       "style":"solid",
       "color":"#63A8A6",
       "radius":"0px"
   },
   "header_background_color":"#153F4C",
   "header_box_shadow":"0px 1px 3px rgba(0,0,0,0.12), 0px 1px 2px rgba(0,0,0,0.24)",
   "header_margin":"0px 0px 15px 0px",
   "header_padding":"0px",
   "text":"#CBE2E2",
   "report_font_family":"Computer Modern",
   "report_font_size":"12px",
   "report_background_page":"white",
   "report_background_content":"#FAFBFC",
   "report_text":"black"
}

