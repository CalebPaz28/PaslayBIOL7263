---
  title: "Practice(Lecture2)"
author: "Caleb Paslay"
date: "`r Sys.Date()`"
output: html_document
---
  # Header 1
  ## Header 2
  ### Header 3
  *Italics*  
  **Bold**  
  ~subscript~  
  ^superscript^  
  ~~strikethrough~~  
  
  > quote text

Two spaces will put words on the next line.


Is that really  
true
Adding a weblink:
  [Toomey](https://mbtoomey.net)

Images:
  ![Penguin]()


**Lists** 
  
  - Item1  
- Item2  
- Item_Level2
- Item_level3
- Item_Level4

## Fencing

```
This is plain text
```
we can also use backticks to put `plain text` inline. 

Execute R code inline `r (3 + 5)*pi`

___

This is a spacer line

## Tables

| Species| Awesomeness
|:-----| :-----
  | House sparrow | medium | 
  Tree sparrow | High

## Equations
see notes!
  In-line $
  Centered $$
  
  ```{r}
Lnk <- "https://github.com/mbtoomey/Biol_7263/blob/main/Data/yeast.Rdata?raw=true"
download.file(Lnk, "yeast.Rdata", mode = "wb")
load("yeast.Rdata")
```

```{r}
head
```


