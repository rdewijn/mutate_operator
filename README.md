# Transform Operator

##### Description

The `Transform Operator` can be used to apply a transformation or mutation to input data using a simple R expression.

##### Usage

Input projection|.
---|---
`y-axis`        | input values
`row`           | row factors
`column`        | columns factors


Output relations|.
---|---
`Operator view`        | view of the Shiny application
`result`  | transformed values

##### Details

Define the R expression in the shiny view. The R-expression is applied as a summary function to each cell in the cross tab view. Hence, the expression should only return a single value per cell.


