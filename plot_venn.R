library(UpSetR)
# These are still not the right numbers, because the totals are wrong. If you analyse this ,count the pairs again!
expressionInput <- c(E.multilocularis=429-(60-37-27)-(269-37-95)-(229-27-95),
                     F.hepatica=884-(160-37-27)-(115-37-4)-(102-27-4),
                     H.microstoma=311-(269-37-95)-(115-37-4)-(174-95-4),
                     T.multiceps=257-(229-27-95) - (174-95-4) - (102-27-4),
                     'F.hepatica&E.multilocularis'=160-37-27,
                     'H.microstoma&E.multilocularis'=269-37-95,
                     'T.multiceps&E.multilocularis'=229-27-95,
                     'H.microstoma&F.hepatica'=115-37-4,
                     'T.multiceps&H.microstoma'=174-95-4,
                     'T.multiceps&F.hepatica'=102-27-4,
                     'E.multilocularis&F.hepatica&H.microstoma'=37,
                     'E.multilocularis&F.hepatica&T.multiceps'=27,
                     'E.multilocularis&H.microstoma&T.multiceps'=95,
                     'F.hepatica&H.microstoma&T.multiceps'=4,
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
