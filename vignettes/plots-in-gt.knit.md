---
title: "Graphing in gt"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Plotting in gt}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



## Graphs vs Tables


Per Stephen Few in his book, [_Show Me the Numbers_](http://www.stephen-few.com/smtn.php):

The difference between Tables and Graphs:  

> Tables: Display used to look up and compare individual values  

> Graphs: Display used to reveal relationships among whole sets of values and their overall   shape

While we typically reach for our graphing tools whenever we want to tell a story with data, we are likely underutilizing tables. We can merge graphs and tables to often get the best of both worlds.

## Get started

We can first load our libraries.


```r
library(gt)
library(gtExtras)
library(dplyr, warn.conflicts =  FALSE)
library(ggplot2)
```

### Sparklines

Per [Wikipedia](https://en.wikipedia.org/wiki/Sparkline):

> A sparkline is a very small line chart, typically drawn without axes or coordinates. It presents the general shape of the variation (typically over time) in some measurement, such as temperature or stock market price, in a simple and highly condensed way.

![A 1999 screenshot of an implementation of sparklines developed around January 1998. The concept was developed by interaction designer Peter Zelchenko in conversation with programmer Michael Medved, while Medved was developing the QuoteTracker application. The product was later sold to Ameritrade.](https://upload.wikimedia.org/wikipedia/commons/9/95/Screenshot_of_Sparklines_in_Medved_QuoteTracker%2C_1998.png)

We can use `gtExtras::gt_sparkline()` to add an inline sparkline very quickly. A necessary prep step is to first convert from a long data format to a summarized data format, where each row represents one "group" and the data column is now a vector of the values.


```r
mtcars %>% 
  head()
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

By using `summarize(list_data = list(col_name))` we can create a list-column of ALL the data for that group.


```r
car_summary <- mtcars %>%
  dplyr::group_by(cyl) %>%
  
  dplyr::summarize(
    mean = mean(mpg),
    sd = sd(mpg),
    # must end up with list of data for each row in the input dataframe
    mpg_data = list(mpg),
    .groups = "drop"
  )

car_summary
#> # A tibble: 3 × 4
#>     cyl  mean    sd mpg_data  
#>   <dbl> <dbl> <dbl> <list>    
#> 1     4  26.7  4.51 <dbl [11]>
#> 2     6  19.7  1.45 <dbl [7]> 
#> 3     8  15.1  2.56 <dbl [14]>
```


```r
car_summary %>%
  arrange(desc(cyl)) %>% 
  gt() %>%
  gtExtras::gt_sparkline(mpg_data) %>%
  fmt_number(columns = mean:sd, decimals = 1)
```

```{=html}
<div id="igjxzcihnw" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#igjxzcihnw .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#igjxzcihnw .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#igjxzcihnw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#igjxzcihnw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#igjxzcihnw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#igjxzcihnw .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#igjxzcihnw .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#igjxzcihnw .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#igjxzcihnw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#igjxzcihnw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#igjxzcihnw .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#igjxzcihnw .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#igjxzcihnw .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#igjxzcihnw .gt_from_md > :first-child {
  margin-top: 0;
}

#igjxzcihnw .gt_from_md > :last-child {
  margin-bottom: 0;
}

#igjxzcihnw .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#igjxzcihnw .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#igjxzcihnw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#igjxzcihnw .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#igjxzcihnw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#igjxzcihnw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#igjxzcihnw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#igjxzcihnw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#igjxzcihnw .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#igjxzcihnw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#igjxzcihnw .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#igjxzcihnw .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#igjxzcihnw .gt_left {
  text-align: left;
}

#igjxzcihnw .gt_center {
  text-align: center;
}

#igjxzcihnw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#igjxzcihnw .gt_font_normal {
  font-weight: normal;
}

#igjxzcihnw .gt_font_bold {
  font-weight: bold;
}

#igjxzcihnw .gt_font_italic {
  font-style: italic;
}

#igjxzcihnw .gt_super {
  font-size: 65%;
}

#igjxzcihnw .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">cyl</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">sd</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">mpg_data</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_right">8</td>
<td class="gt_row gt_right">15.1</td>
<td class="gt_row gt_right">2.6</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><polyline points='2.95,1.98 7.48,5.84 12.01,4.00 16.54,3.21 21.07,5.05 25.60,9.26 30.13,9.26 34.67,5.49 39.20,4.79 43.73,5.05 48.26,6.71 52.79,1.54 57.32,4.52 61.85,5.22 ' style='stroke-width: 1.07; stroke: #D3D3D3; stroke-linecap: butt;' /><circle cx='25.60' cy='9.26' r='0.89' style='stroke-width: 0.71; stroke: #FF0000; fill: #FF0000;' /><circle cx='30.13' cy='9.26' r='0.89' style='stroke-width: 0.71; stroke: #FF0000; fill: #FF0000;' /><circle cx='52.79' cy='1.54' r='0.89' style='stroke-width: 0.71; stroke: #0000FF; fill: #0000FF;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">19.7</td>
<td class="gt_row gt_right">1.5</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><polyline points='2.95,2.40 12.76,2.40 22.58,1.54 32.40,8.61 42.22,6.26 52.04,9.26 61.85,5.19 ' style='stroke-width: 1.07; stroke: #D3D3D3; stroke-linecap: butt;' /><circle cx='52.04' cy='9.26' r='0.89' style='stroke-width: 0.71; stroke: #FF0000; fill: #FF0000;' /><circle cx='22.58' cy='1.54' r='0.89' style='stroke-width: 0.71; stroke: #0000FF; fill: #0000FF;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">26.7</td>
<td class="gt_row gt_right">4.5</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><polyline points='2.95,8.39 8.84,7.41 14.73,8.39 20.62,2.47 26.51,3.70 32.40,1.54 38.29,9.20 44.18,5.62 50.07,6.42 55.96,3.70 61.85,9.26 ' style='stroke-width: 1.07; stroke: #D3D3D3; stroke-linecap: butt;' /><circle cx='61.85' cy='9.26' r='0.89' style='stroke-width: 0.71; stroke: #FF0000; fill: #FF0000;' /><circle cx='32.40' cy='1.54' r='0.89' style='stroke-width: 0.71; stroke: #0000FF; fill: #0000FF;' /></g></svg></td></tr>
  </tbody>
  
  
</table>
</div>
```

### Inline Win Loss plots

You can also generate really nice looking "Win Loss" plots, similar to the ones used by [The Guardian](https://www.theguardian.com/football/premierleague/table) for Soccer outcomes. The code to bring in the data via the `{nflreadr}` package is hidden in an expandable tab below.

<details><Summary>Bring data in</summary>


```r
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
#> ✓ tibble  3.1.3          ✓ purrr   0.3.4     
#> ✓ tidyr   1.1.3          ✓ stringr 1.4.0.9000
#> ✓ readr   2.0.0          ✓ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

games_df <- nflreadr::load_schedules() %>%
  filter(season == 2020, game_type == "REG") %>%
  select(game_id, team_home = home_team, team_away = away_team, result, week) %>%
  pivot_longer(contains('team'), names_to = 'home_away', values_to = 'team', names_prefix = 'team_') %>%
  mutate(
    result = ifelse(home_away == 'home', result, -result),
    win = ifelse(result == 0 , 0.5, ifelse(result > 0, 1, 0))
  ) %>%
  select(week, team, win) %>%
  mutate(
    team = case_when(
      team == 'STL' ~ 'LA',
      team == 'OAK' ~ 'LV',
      team == 'SD' ~ 'LAC',
      T ~ team
    )
  )

team_df <- nflreadr::load_teams() %>%
  select(team_wordmark, team_abbr, team_conf, team_division)

joined_df <- games_df %>%
  group_by(team) %>%
  summarise(
    Wins = length(win[win==1]),
    Losses = length(win[win==0]),
    outcomes = list(win), .groups = "drop") %>%
  left_join(team_df, by = c("team" = "team_abbr")) %>%
  select(team_wordmark, team_conf, team_division, Wins:outcomes)

final_df <- joined_df %>%
  filter(team_conf == "AFC") %>%
  group_by(team_division) %>%
  arrange(desc(Wins)) %>%
  ungroup() %>%
  arrange(team_division) %>%
  select(-team_conf) %>%
  mutate(team_division = str_remove(team_division, "AFC |NFC ")) %>%
  mutate(
    team_division = factor(team_division,
      levels = c("North", "South", "East", "West")
      )
    ) %>%
  arrange(team_division)
```

</details>

Note that we have a list-column of the outcomes for each team.


```r
glimpse(final_df)
#> Rows: 16
#> Columns: 5
#> $ team_wordmark <chr> "https://github.com/nflverse/nflfastR-data/raw/master/wo…
#> $ team_division <fct> North, North, North, North, South, South, South, South, …
#> $ Wins          <int> 12, 11, 11, 4, 11, 11, 4, 1, 13, 10, 7, 2, 14, 8, 7, 5
#> $ Losses        <int> 4, 5, 5, 11, 5, 5, 12, 15, 3, 6, 9, 14, 2, 8, 9, 11
#> $ outcomes      <list> <1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0>, <1, 1,…
```

And now we can generate an example table!


```r
final_df %>%
  gt(groupname_col = "team_division") %>%
  cols_label(team_wordmark = "") %>%
  cols_align("left", team_division) %>%
  gtExtras::gt_plt_winloss(outcomes, max_wins = 16, type = "pill") %>%
  gtExtras::gt_img_rows(columns = team_wordmark, height = 20) %>%
  gtExtras::gt_theme_538() %>%
  tab_header(
    title = gtExtras::add_text_img(
      "2020 Results by Division",
      url = "https://github.com/nflverse/nflfastR-data/raw/master/AFC.png",
      height = 30
    )
  ) %>%
  tab_options(data_row.padding = px(2))
```

```{=html}
<div id="dthteegcrk" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=Chivo:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
html {
  font-family: Chivo, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#dthteegcrk .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: 300;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: none;
  border-top-width: 3px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dthteegcrk .gt_heading {
  background-color: #FFFFFF;
  text-align: left;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dthteegcrk .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dthteegcrk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dthteegcrk .gt_bottom_border {
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dthteegcrk .gt_col_headings {
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #000000;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dthteegcrk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: normal;
  text-transform: uppercase;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dthteegcrk .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: normal;
  text-transform: uppercase;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dthteegcrk .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dthteegcrk .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dthteegcrk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #000000;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dthteegcrk .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #000000;
  border-bottom-style: solid;
  border-bottom-width: 1px;
  border-bottom-color: #000000;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#dthteegcrk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #000000;
  border-bottom-style: solid;
  border-bottom-width: 1px;
  border-bottom-color: #000000;
  vertical-align: middle;
}

#dthteegcrk .gt_from_md > :first-child {
  margin-top: 0;
}

#dthteegcrk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dthteegcrk .gt_row {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dthteegcrk .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#dthteegcrk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dthteegcrk .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#dthteegcrk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dthteegcrk .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dthteegcrk .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dthteegcrk .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dthteegcrk .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dthteegcrk .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#dthteegcrk .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dthteegcrk .gt_sourcenote {
  font-size: 12px;
  padding: 4px;
}

#dthteegcrk .gt_left {
  text-align: left;
}

#dthteegcrk .gt_center {
  text-align: center;
}

#dthteegcrk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dthteegcrk .gt_font_normal {
  font-weight: normal;
}

#dthteegcrk .gt_font_bold {
  font-weight: bold;
}

#dthteegcrk .gt_font_italic {
  font-style: italic;
}

#dthteegcrk .gt_super {
  font-size: 65%;
}

#dthteegcrk .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="4" class="gt_heading gt_title gt_font_normal gt_bottom_border" style><div style='display:inline;vertical-align: top;'>2020 Results by Division</div><div style='display:inline;margin-left:10px'><img src="https://github.com/nflverse/nflfastR-data/raw/master/AFC.png" style="height:30px;"></div></th>
    </tr>
    
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;"></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;">Wins</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;">Losses</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;">outcomes</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">North</td>
    </tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/PIT.png" style="height:20px;"></td>
<td class="gt_row gt_right">12</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='1.89' x2='23.20' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='8.91' x2='52.65' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/BAL.png" style="height:20px;"></td>
<td class="gt_row gt_right">11</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='1.89' x2='23.20' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/CLE.png" style="height:20px;"></td>
<td class="gt_row gt_right">11</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='8.91' x2='30.56' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/CIN.png" style="height:20px;"></td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">11</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='6.10' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #BEBEBE;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">South</td>
    </tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/IND.png" style="height:20px;"></td>
<td class="gt_row gt_right">11</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='1.89' x2='23.20' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='8.91' x2='30.56' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/TEN.png" style="height:20px;"></td>
<td class="gt_row gt_right">11</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/HOU.png" style="height:20px;"></td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">12</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='8.91' x2='52.65' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/JAX.png" style="height:20px;"></td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">15</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='8.91' x2='30.56' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='8.91' x2='52.65' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">East</td>
    </tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/BUF.png" style="height:20px;"></td>
<td class="gt_row gt_right">13</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/MIA.png" style="height:20px;"></td>
<td class="gt_row gt_right">10</td>
<td class="gt_row gt_right">6</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='1.89' x2='23.20' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/NE.png" style="height:20px;"></td>
<td class="gt_row gt_right">7</td>
<td class="gt_row gt_right">9</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='8.91' x2='52.65' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/NYJ.png" style="height:20px;"></td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">14</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='8.91' x2='30.56' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr class="gt_group_heading_row">
      <td colspan="4" class="gt_group_heading">West</td>
    </tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/KC.png" style="height:20px;"></td>
<td class="gt_row gt_right">14</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='1.89' x2='12.15' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='1.89' x2='23.20' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='1.89' x2='41.60' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/LV.png" style="height:20px;"></td>
<td class="gt_row gt_right">8</td>
<td class="gt_row gt_right">8</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='1.89' x2='8.47' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='1.89' x2='30.56' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='34.24' y1='1.89' x2='34.24' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='37.92' y1='8.91' x2='37.92' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='1.89' x2='45.29' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='48.97' y1='8.91' x2='48.97' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='52.65' y1='8.91' x2='52.65' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/LAC.png" style="height:20px;"></td>
<td class="gt_row gt_right">7</td>
<td class="gt_row gt_right">9</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='1.89' x2='4.79' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='8.91' x2='15.83' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='19.51' y1='8.91' x2='19.51' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='23.20' y1='1.89' x2='23.20' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='26.88' y1='8.91' x2='26.88' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='30.56' y1='8.91' x2='30.56' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='1.89' x2='52.65' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='56.33' y1='1.89' x2='56.33' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='60.01' y1='1.89' x2='60.01' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /></g></svg></td></tr>
    <tr><td class="gt_row gt_left" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;"><img src="https://github.com/nflverse/nflfastR-data/raw/master/wordmarks/DEN.png" style="height:20px;"></td>
<td class="gt_row gt_right" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;">5</td>
<td class="gt_row gt_right" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;">11</td>
<td class="gt_row gt_center" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='64.80pt' height='10.80pt' viewBox='0 0 64.80 10.80'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHw2NC44MHwwLjAwfDEwLjgw'>    <rect x='0.00' y='0.00' width='64.80' height='10.80' />  </clipPath></defs><g clip-path='url(#cpMC4wMHw2NC44MHwwLjAwfDEwLjgw)'><line x1='4.79' y1='8.91' x2='4.79' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='8.47' y1='8.91' x2='8.47' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='12.15' y1='8.91' x2='12.15' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='15.83' y1='1.89' x2='15.83' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='19.51' y1='1.89' x2='19.51' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='23.20' y1='8.91' x2='23.20' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='26.88' y1='1.89' x2='26.88' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='30.56' y1='8.91' x2='30.56' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='34.24' y1='8.91' x2='34.24' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='37.92' y1='1.89' x2='37.92' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='41.60' y1='8.91' x2='41.60' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='45.29' y1='8.91' x2='45.29' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='48.97' y1='1.89' x2='48.97' y2='6.10' style='stroke-width: 2.13; stroke: #013369;' /><line x1='52.65' y1='8.91' x2='52.65' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='56.33' y1='8.91' x2='56.33' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /><line x1='60.01' y1='8.91' x2='60.01' y2='4.70' style='stroke-width: 2.13; stroke: #D50A0A;' /></g></svg></td></tr>
  </tbody>
  
  
</table>
</div>
```

### Inline bar plots

We can also do inline bar plots, purely via HTML! You can customize the colors, and have the option to scale or use unscaled values.


```r
gt_bar_plot_tab <- mtcars %>%
  head() %>%
  dplyr::select(cyl, mpg) %>%
  dplyr::mutate(
    mpg_pct_max = round(mpg / max(mpg) * 100, digits = 2),
    mpg_scaled = mpg / max(mpg) * 100
  ) %>%
  dplyr::mutate(mpg_unscaled = mpg) %>%
  gt() %>%
  gt_plt_bar(column = mpg_scaled, scaled = TRUE) %>%
  gt_plt_bar(column = mpg_unscaled, scaled = FALSE, fill = "blue", background = "lightblue") %>%
  cols_align("center", contains("scale")) %>%
  cols_width(
    4 ~ px(125),
    5 ~ px(125)
  )

gt_bar_plot_tab
```

```{=html}
<div id="bzvpbeltfq" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#bzvpbeltfq .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#bzvpbeltfq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bzvpbeltfq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bzvpbeltfq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bzvpbeltfq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bzvpbeltfq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bzvpbeltfq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#bzvpbeltfq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#bzvpbeltfq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bzvpbeltfq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bzvpbeltfq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#bzvpbeltfq .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#bzvpbeltfq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#bzvpbeltfq .gt_from_md > :first-child {
  margin-top: 0;
}

#bzvpbeltfq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bzvpbeltfq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#bzvpbeltfq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#bzvpbeltfq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bzvpbeltfq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#bzvpbeltfq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bzvpbeltfq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bzvpbeltfq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bzvpbeltfq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bzvpbeltfq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bzvpbeltfq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#bzvpbeltfq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bzvpbeltfq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#bzvpbeltfq .gt_left {
  text-align: left;
}

#bzvpbeltfq .gt_center {
  text-align: center;
}

#bzvpbeltfq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bzvpbeltfq .gt_font_normal {
  font-weight: normal;
}

#bzvpbeltfq .gt_font_bold {
  font-weight: bold;
}

#bzvpbeltfq .gt_font_italic {
  font-style: italic;
}

#bzvpbeltfq .gt_super {
  font-size: 65%;
}

#bzvpbeltfq .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table" style="table-layout: fixed;">
  <colgroup>
    <col/>
    <col/>
    <col/>
    <col style="width:125px;"/>
    <col style="width:125px;"/>
  </colgroup>
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">cyl</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">mpg</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">mpg_pct_max</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">mpg_scaled</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">mpg_unscaled</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">21.0</td>
<td class="gt_row gt_right">92.11</td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:#e1e1e1;'><div style='background:purple;width:92.1052631578947%;height:16px;'></div></div></td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:lightblue;'><div style='background:blue;width:92.1052631578947%;height:16px;'></div></div></td></tr>
    <tr><td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">21.0</td>
<td class="gt_row gt_right">92.11</td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:#e1e1e1;'><div style='background:purple;width:92.1052631578947%;height:16px;'></div></div></td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:lightblue;'><div style='background:blue;width:92.1052631578947%;height:16px;'></div></div></td></tr>
    <tr><td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">22.8</td>
<td class="gt_row gt_right">100.00</td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:#e1e1e1;'><div style='background:purple;width:100%;height:16px;'></div></div></td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:lightblue;'><div style='background:blue;width:100%;height:16px;'></div></div></td></tr>
    <tr><td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">21.4</td>
<td class="gt_row gt_right">93.86</td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:#e1e1e1;'><div style='background:purple;width:93.859649122807%;height:16px;'></div></div></td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:lightblue;'><div style='background:blue;width:93.859649122807%;height:16px;'></div></div></td></tr>
    <tr><td class="gt_row gt_right">8</td>
<td class="gt_row gt_right">18.7</td>
<td class="gt_row gt_right">82.02</td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:#e1e1e1;'><div style='background:purple;width:82.0175438596491%;height:16px;'></div></div></td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:lightblue;'><div style='background:blue;width:82.0175438596491%;height:16px;'></div></div></td></tr>
    <tr><td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">18.1</td>
<td class="gt_row gt_right">79.39</td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:#e1e1e1;'><div style='background:purple;width:79.3859649122807%;height:16px;'></div></div></td>
<td class="gt_row gt_center"><div style='flex-grow:1;margin-left:8px;background:lightblue;'><div style='background:blue;width:79.3859649122807%;height:16px;'></div></div></td></tr>
  </tbody>
  
  
</table>
</div>
```

### Stacked Percent bar charts

We can create a horizontal stacked percent bar chart inline like so. The data can be prepped as seen in the expandable section below.

<details>

```r
library(tidyverse)
library(gt)

player_df <- tibble(
  player = c(
    "Evan Mobley",
    "Sandro Mamukelashvili",
    "Charles Bassey",
    "Luke Garza",
    "Moses Wright",
    "Neemias Queta",
    "Isaiah Jackson",
    "Day'Ron Sharpe"
  ),
  team = c(
    "USC", "Seton Hall", "Western Kentucky",
    "Iowa", "Georgia Tech", "Utah St", "Kentucky",
    "North Carolina"
  ),
  ht = c(
    "7'0\"",
    "6'10\"",
    "6'10\"",
    "6'11\"",
    "6'9\"",
    "7'1\"",
    "6'11\"",
    "6'10\""
  ),
  dk_pct_time = c(40, 48, 50, 50, 51, 55, 60, 66),
  dk_pps = c(1.62, 1.02, 1.54,1.33,1.46,1.37,1.33,1.18),
  tip_pct_time = c(26, 10, 19, 15, 25, 27, 15, 24),
  tip_pps = c(0.88, .97,1,1.05, .63, .85, .76, .84),
  jmp_pct_time = c(33, 42, 31, 35, 25, 18, 25, 10),
  jmp_pps = c(.91, .91, .78, 1.04, .86, .74, .71, .42)
) %>%
  left_join(
    tibble(
      player = c(
        "Evan Mobley",
        "Sandro Mamukelashvili",
        "Charles Bassey",
        "Luke Garza",
        "Moses Wright",
        "Neemias Queta",
        "Isaiah Jackson",
        "Day'Ron Sharpe"
      ) %>% rep(each = 3),
      shot_type = c("Dunks + Lays", "Hooks + Floats", "Jumpers") %>% rep(8)
    ) %>%
      mutate(
        shot_type = factor(shot_type, levels = c("Jumpers", "Hooks + Floats", "Dunks + Lays")),
        shot_mix = c(
          40, 26, 33,
          48, 10, 42,
          50, 19, 31,
          50, 15, 35,
          51, 25, 25,
          55, 27, 18,
          60, 15, 25,
          66, 24, 10
        )
      ),
    by = "player"
  )
```

</details>


```r
basic_tb <- player_df %>%
  group_by(player) %>%
  summarize(dunks = shot_mix[1], list_data = list(shot_mix)) %>%
  arrange(dunks) %>%
  gt()
```


```r
basic_tb %>%
  gt_plt_bar_stack(list_data, width = 65,
                   labels = c("DUNKS", "HOOKS/FLOATS", "JUMPERS"),
                   palette= c("#ff4343", "#bfbfbf", "#0a1c2b")) %>%
  gt_theme_538()
```

```{=html}
<div id="ktdtvtvqpx" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=Chivo:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
html {
  font-family: Chivo, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ktdtvtvqpx .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: 300;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: none;
  border-top-width: 3px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ktdtvtvqpx .gt_heading {
  background-color: #FFFFFF;
  text-align: left;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ktdtvtvqpx .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ktdtvtvqpx .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ktdtvtvqpx .gt_bottom_border {
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ktdtvtvqpx .gt_col_headings {
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #000000;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ktdtvtvqpx .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: normal;
  text-transform: uppercase;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ktdtvtvqpx .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: normal;
  text-transform: uppercase;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ktdtvtvqpx .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ktdtvtvqpx .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ktdtvtvqpx .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #000000;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ktdtvtvqpx .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #000000;
  border-bottom-style: solid;
  border-bottom-width: 1px;
  border-bottom-color: #000000;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ktdtvtvqpx .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #000000;
  border-bottom-style: solid;
  border-bottom-width: 1px;
  border-bottom-color: #000000;
  vertical-align: middle;
}

#ktdtvtvqpx .gt_from_md > :first-child {
  margin-top: 0;
}

#ktdtvtvqpx .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ktdtvtvqpx .gt_row {
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ktdtvtvqpx .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 80%;
  font-weight: bolder;
  text-transform: uppercase;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ktdtvtvqpx .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ktdtvtvqpx .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ktdtvtvqpx .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ktdtvtvqpx .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ktdtvtvqpx .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ktdtvtvqpx .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ktdtvtvqpx .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ktdtvtvqpx .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ktdtvtvqpx .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ktdtvtvqpx .gt_sourcenote {
  font-size: 12px;
  padding: 4px;
}

#ktdtvtvqpx .gt_left {
  text-align: left;
}

#ktdtvtvqpx .gt_center {
  text-align: center;
}

#ktdtvtvqpx .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ktdtvtvqpx .gt_font_normal {
  font-weight: normal;
}

#ktdtvtvqpx .gt_font_bold {
  font-weight: bold;
}

#ktdtvtvqpx .gt_font_italic {
  font-style: italic;
}

#ktdtvtvqpx .gt_super {
  font-size: 65%;
}

#ktdtvtvqpx .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;">player</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;">dunks</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="border-top-width: 0px; border-top-style: solid; border-top-color: black;"><span style='color:#ff4343'><b>DUNKS</b></span>||<span style='color:#bfbfbf'><b>HOOKS/FLOATS</b></span>||<span style='color:#0a1c2b'><b>JUMPERS</b></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">Evan Mobley</td>
<td class="gt_row gt_right">40</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='63.03' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='63.03' y='-0.0000000000000036' width='40.97' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='104.00' y='-0.0000000000000036' width='52.00' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='31.52' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>40</text><text x='83.52' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>26</text><text x='130.00' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>33</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left">Sandro Mamukelashvili</td>
<td class="gt_row gt_right">48</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='74.88' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='74.88' y='-0.0000000000000036' width='15.60' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='90.48' y='-0.0000000000000036' width='65.52' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='37.44' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>48</text><text x='82.68' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>10</text><text x='123.24' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>42</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left">Charles Bassey</td>
<td class="gt_row gt_right">50</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='78.00' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='78.00' y='-0.0000000000000036' width='29.64' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='107.64' y='-0.0000000000000036' width='48.36' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='39.00' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>50</text><text x='92.82' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>19</text><text x='131.82' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>31</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left">Luke Garza</td>
<td class="gt_row gt_right">50</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='78.00' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='78.00' y='-0.0000000000000036' width='23.40' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='101.40' y='-0.0000000000000036' width='54.60' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='39.00' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>50</text><text x='89.70' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>15</text><text x='128.70' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>35</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left">Moses Wright</td>
<td class="gt_row gt_right">51</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='78.77' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='78.77' y='-0.0000000000000036' width='38.61' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='117.39' y='-0.0000000000000036' width='38.61' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='39.39' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>51</text><text x='98.08' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>25</text><text x='136.69' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>25</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left">Neemias Queta</td>
<td class="gt_row gt_right">55</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='85.80' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='85.80' y='-0.0000000000000036' width='42.12' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='127.92' y='-0.0000000000000036' width='28.08' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='42.90' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>55</text><text x='106.86' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>27</text><text x='141.96' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>18</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left">Isaiah Jackson</td>
<td class="gt_row gt_right">60</td>
<td class="gt_row gt_center"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='93.60' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='93.60' y='-0.0000000000000036' width='23.40' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='117.00' y='-0.0000000000000036' width='39.00' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='46.80' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>60</text><text x='105.30' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>15</text><text x='136.50' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>25</text></g></svg></td></tr>
    <tr><td class="gt_row gt_left" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;">Day'Ron Sharpe</td>
<td class="gt_row gt_right" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;">66</td>
<td class="gt_row gt_center" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: transparent;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='156.00pt' height='14.40pt' viewBox='0 0 156.00 14.40'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA=='>    <rect x='0.00' y='0.00' width='156.00' height='14.40' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNTYuMDB8MC4wMHwxNC40MA==)'><rect x='0.00' y='-0.0000000000000036' width='102.96' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #FF4343;' /><rect x='102.96' y='-0.0000000000000036' width='37.44' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #BFBFBF;' /><rect x='140.40' y='-0.0000000000000036' width='15.60' height='14.40' style='stroke-width: 2.13; stroke: #FFFFFF; stroke-linecap: square; stroke-linejoin: miter; fill: #0A1C2B;' /><text x='51.48' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>66</text><text x='121.68' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>24</text><text x='148.20' y='9.67' text-anchor='middle' style='font-size: 8.54px; font-weight: 0; fill: #FFFFFF; font-family: Courier;' textLength='10.24px' lengthAdjust='spacingAndGlyphs'>10</text></g></svg></td></tr>
  </tbody>
  
  
</table>
</div>
```

