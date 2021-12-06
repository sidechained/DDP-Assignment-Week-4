---
title       : Berlin Bathroom Beacon 
subtitle    : Reproducible Pitch Presentation
author      : Graham Booth
job         : Coursera / John Hopkins University "Data Science Specialisation" Candidate
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
em {
  font-style: italic
}

strong {
  font-weight: bold;
}

sup {
  top: -0.5em;
  vertical-align: baseline;
  font-size: 75%;
  line-height: 0;
  position: relative;
}
</style>



## Aims of the Project

<br>
The Berlin Bathroom Beacon aims to:

- make use of freely available location data about public toilets in Berlin
- bring this to the fingertips of the public...when they need it most!

<br>

Our initial survey found that the most important factors when using a public bathroom are:

1. How close is it to my current location?
2. What are the facilities like? Are they accessible?
3. Are the facilities free or paid?  
(some preferred the former,  
whilst others considered paid facilities to be cleaner or better maintained)

Our web-based app focuses on bringing these three attributes to users simply and efficiently.

--- .class #id 

## The Data

- Our app uses a publicly available [dataset](https://daten.berlin.de/datensaetze/standorte-der-öffentlichen-toiletten) as part of the Berlin Open Data project
- The licence allows the data to be used for commercial purposes  
(Only a simple attribution must be given i.e. copyright/rights notice and a link to the license)



The data contains the following attributes:
- _LavatoryID, Description, City, Street, Number, PostalCode, Country, Longitude, Latitude, isOwnedByWall, isHandicappedAccessible, Price, canBePayedWithCoins, canBePayedInApp, canBePayedWithNFC, hasChangingTable, LabelID, hasUrinal_

Of which we used:
- _PostalCode, Longitude, Latitude, isHandicappedAccessible, Price_

You can see there is plenty of room in the data to add more features to the app as it matures...

--- .class #id 

## Demo of the App

<img src="BBB-screenshot.png" alt="drawing" style="height:450px;"/>

Click [here](https://sidechained.shinyapps.io/ddp_shiny/) to open the app in your browser and [here](https://github.com/sidechained/DDP-Assignment-Week-4) to see the code on github 

--- .class #id 

## Conclusion / Improvments for V1.1

V1.0 is a simple working prototype...our work goes on!

Forthcoming improvements in v1.1 include:
- Addition of a "closest to me" function and links to Google/Apple Maps navigation
- Better icons for differentiating facilities  
_(e.g. gender neutrality, has urinal or not)_
- Allowing search by district as well as postcode  
_(i.e. Mitte, Neukölln)_
- Overlaying district and postcode boundaries on the map  
_(open source shape datasets exist for this)_

Thanks for your consideration - we look forward to your support!
