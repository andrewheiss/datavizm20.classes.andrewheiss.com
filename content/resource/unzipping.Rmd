---
title: "Unzipping files"
date: "2020-05-06"
menu:
  resource:
    parent: Guides
type: docs
weight: 4
---

Because RStudio projects typically consist of multiple files (R scripts, datasets, graphical output, etc.) the easiest way to distribute them to you for examples, assignments, and projects is to combine all the different files in to a single compressed collection called a **zip file**. When you unzip a zipped file, your operating system extracts all the files that are contained inside into a new folder on your computer.

Unzipping files on macOS is trivial, but unzipping files on Windows can mess you up if you don't pay careful attention. Here's a helpful guide to unzipping files on both macOS and Windows.


## Unzipping files on macOS

Double click on the downloaded `.zip` file. macOS will automatically create a new folder with the same name as the `.zip` file, and all the file's contents will be inside. Double click on the RStudio Project file (`.Rproj`) to get started.

```{r, echo=FALSE, out.width="60%"}
knitr::include_graphics("/img/unzipping/unzip-mac.png", error = FALSE)
```


## Unzipping files on Windows

***tl;dr**: Right click on the `.zip` file, select "Extract All…", and work with the resulting unzipped folder.*

Unlike macOS, Windows does *not* automatically unzip things for you. If you double click on the `.zip` file, Windows will show you what's inside, but it will do so without actually extracting anything. This ~~can be~~ is incredibly confusing! Here's what it looks like—the only clues that this folder is really a `.zip` file are that there's a "Compressed Folder Tools" tab at the top, and there's a "Ratio" column that shows how much each file is compressed. 

```{r, echo=FALSE, out.width="80%"}
knitr::include_graphics("/img/unzipping/inside-zip-windows.png", error = FALSE)
```

It is very tempting to try to open files from this view. However, if you do, things will break and you won't be able to correctly work with any of the files in the zipped folder. If you open the R Project file, for instance, RStudio will point to a bizarre working directory buried deep in some temporary folder:

```{r, echo=FALSE, out.width="60%"}
knitr::include_graphics("/img/unzipping/temp-wd-windows.png", error = FALSE)
```

You most likely won't be able to open any data files or save anything, which will be frustrating.

Instead, you need to right click on the `.zip` file and select "Extract All…":

```{r, echo=FALSE, out.width="60%"}
knitr::include_graphics("/img/unzipping/extract-windows-1.png", error = FALSE)
```

Then choose where you want to unzip all the files and click on "Extract"

```{r, echo=FALSE, out.width="60%"}
knitr::include_graphics("/img/unzipping/extract-windows-2.png", error = FALSE)
```

You should then finally have a real folder with all the contents of the zipped file. Open the R Project file and RStudio will point to the correct working directory and everything will work.

```{r, echo=FALSE, out.width="60%"}
knitr::include_graphics("/img/unzipping/extract-windows-3.png", error = FALSE)
```
