library(UpSetR)
expressionInput <- c(E.multilocularis=429,F.hepatica=884,H.microstoma=311,T.multiceps=257,
                     'F.hepatica&E.multilocularis'=160,
                     'H.microstoma&E.multilocularis'=269,
                     'T.multiceps&E.multilocularis'=229,
                     'H.microstoma&F.hepatica'=115,
                     'T.multiceps&H.microstoma'=174,
                     'T.multiceps&F.hepatica'=102,
                     'E.multilocularis&F.hepatica&H.microstoma'=105,
                     'E.multilocularis&F.hepatica&T.multiceps'=95,
                     'E.multilocularis&H.microstoma&T.multiceps'=163,
                     'F.hepatica&H.microstoma&T.multiceps'=72,
                     'E.multilocularis&F.hepatica&H.microstoma&T.multiceps'=68)
               

upset(fromExpression(expressionInput), order.by = "freq",
      point.size = 5, line.size = 1,
      mainbar.y.label = "Ortholog pairs shared with S. mansoni",
      sets.x.label = "Ortholog pairs per species",
      empty.intersections = "on",
      sets.bar.color = "#56B4E9",
      show.numbers = "yes",
      matrix.color="orange",
      text.scale=1.5)
     
dev.off()
