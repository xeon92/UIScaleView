# UIScaleView

## Overview

UIScaleView is inspired by UILabel's adjustsFontSizeToFitWidth property. 

When contents size exceed it's own frame size, label deals with it by scaling font size.

When make complicated layout of view, restricted bounding width or height make problem. if you deal with it only by setting labels' adjustsFontSizeToFitWidth property, the rational frame of layout will be collapsed.

UIScaleView deal with it by scaling overall layout like it is one image.

when a contents view whose minimum width is 200 is inserted into space where width is constrainted to 100, it can inserted into space by scaling 50%. and height is calculated by scaling ratio, so height should be open constrainted.

it's opposite case can be also true. where maximum width of contents is defined. it can be deal with it by scaling view to scaling to ratio that over 100%.


## matching properties

| UIScaleView | UILabel | etc |
|----|----|----|
| defineSmallerScaleToFitWidth | adjustsFontSizeToFitWidth  | |
| defineBiggerScaleToFitWidth | | added |
| minimumScaleFactor | minimumScaleFactor |
| maximumScaleFactor | | added |





