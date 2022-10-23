getDataTable <- function(data){
  DT::datatable(
    data, 
    class = 'cell-border stripe',
    options = list(
      dom = 'ti',
      
      # FixedColumns
      scrollX = TRUE,
      fixedColumns = list(leftColumns = 2),
      
      # Scroller
      deferRender = TRUE,
      scrollY = 400,
      scroller = TRUE
    ),
    extensions = c('FixedColumns', 'Scroller')
  )
}