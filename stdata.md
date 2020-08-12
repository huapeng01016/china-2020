# 使用Stata获取与处理数据

##  [Hua Peng@StataCorp][hpeng]
### 2020 Stata 中国用户大会
### [https://huapeng01016.github.io/china-2020/](https://huapeng01016.github.io/china-2020/)


# 数据的获取

## **import delimited**
````
<<dd_do>>
local date = "08-10-2020"
import delimited "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/`date'.csv", clear
list in 1/5
<</dd_do>>
````

## **import excel**

````
<<dd_do>>
import excel "E:\projects\china-2020\stata\广东数据\广东省新冠肺炎疫情基本情况统计表_1582454685234.xlsx", sheet("Sheet1")
list in 1/5
<</dd_do>>
````

## **import　spss**

````
<<dd_do>>
import spss using "E:\projects\china-2020\stata\manipulate.sav", clear
list in 1/5
<</dd_do>>
````

## **import　sas**

````
<<dd_do>>
import sas using "E:\projects\china-2020\stata\psam_p30.sas7bdat", clear
<</dd_do>>
````

## get data from pandas using **sfi**

````
python:
import pandas as pd
data = pd.read_html("https://www.cdc.gov/coronavirus/2019-ncov/covid-data/covidview/index.html")
df = data[4]
t = df.values.tolist()
````

生成Stata dataset
~~~~
python:
from sfi import Data
Data.addObs(len(t))
stata: gen desc = ""
stata: gen indian = ""
stata: gen balck = ""
stata: gen hisp = ""
stata: gen asian = ""
stata: gen white = ""
Data.store(None, range(len(t)), t)
end
~~~~

<<dd_do: quietly>>
use stata/covid_prop.dta, clear
<</dd_do>>

~~~~
<<dd_do>>
list, clean
<</dd_do>>
~~~~

# 显示数据

## 获得与生成US county shape data
````
copy https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_us_county_500k.zip ///
      cb_2018_us_county_500k.zip
unzipfile cb_2018_us_county_500k.zip

spshape2dta ./cb_2018_us_county_500k/cb_2018_us_county_500k.shp, 	/// 
	saving(usacounties) replace
use usacounties.dta, clear
generate fips = real(GEOID)
save usacounties.dta, replace	
````



## 抓取Covid-19数据

~~~~
local date = "07-30-2020"
python:
import pandas as pd
df = pd.read_csv("https://raw.githubusercontent.com/"\
	"CSSEGISandData/COVID-19/master/csse_covid_19_data/"\
	"csse_covid_19_daily_reports/`date'.csv",\
	dtype={"fips" : np.int32})
df.columns = df.columns.str.lower()
df = df.loc[df['country_region'] == "US"]
df.head()
end
~~~~

## 使用**geopandas**和**plotly**显示数据
~~~~
python:
from urllib.request import urlopen
import numpy as np
import json
with urlopen("https://raw.githubusercontent.com/"\
	"plotly/datasets/master/geojson-counties-fips.json") as response:
    counties = json.load(response)

import pandas as pd
df = pd.read_csv("https://raw.githubusercontent.com/"\
	"CSSEGISandData/COVID-19/master/csse_covid_19_data/"\
	"csse_covid_19_daily_reports/`date'.csv",\
	dtype={"fips" : np.int32})
df.columns = df.columns.str.lower()
df = df.loc[df['country_region'] == "US"]
import plotly.express as px
fig = px.choropleth(df, geojson=counties, locations='fips', 
						color='confirmed',
						hover_data=['combined_key', 'confirmed'],
						color_continuous_scale='Inferno',
						range_color = [100, 5000],
						scope="usa",
                        labels={'confirmed':'confirmed cases'}
                    )
fig.update_layout(margin={"r":0,"t":0,"l":0,"b":0})
fig.show()
# fig.write_html("./stata/`date'-`state'.html")
end
~~~~

##

* [07-30-2020](./stata/07-30-2020-.html)
* [07-30-2020 New York](./stata/07-30-2020-New York.html)
* [07-30-2020 Texas](./stata/07-30-2020-Texas.html)


# 谢谢!

# Post-credits...

- [sfi details and examples][sfi]
- [Stata Python documentation][P python]
- [Stata Python integration](https://www.stata.com/new-in-stata/python-integration/)
- The talk is made with [Stata markdown](https://www.stata.com/features/overview/markdown/) and [dynpandoc](https://ideas.repec.org/c/boc/bocode/s458455.html)
- [wordcloud do-file](./stata/words.do)


[hpeng]: hpeng@stata.com
[sfi]: https://www.stata.com/python/api16/
[P python]:https://www.stata.com/manuals/ppython.pdf
