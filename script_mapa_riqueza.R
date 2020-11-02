
library(leaflet)
library(rgdal)
library(raster)

# BR shape
br = readOGR("D:\\IFgoiano\\Mestrado-CRENAC\\aulas\\espacial\\Estados_do_Brasil\\Brasil.shp")
plot(br, col = "gray")

# rasters
pre <- raster("Riqueza_Presente.asc")
fut <- raster("Riqueza_Futuro.asc")
plot(fut, add = T)
crs(pre) = crs(fut) = crs(br)
pre

# color palette
pal <- colorNumeric("Greens", values(pre), na.color = NA)

# map
m <- leaflet() %>% 
	addTiles() %>% 
	setView(-52, -14, zoom = 4) %>%
	addRasterImage(pre, colors = pal, opacity = 0.9, 
		group = "Presente", maxBytes = Inf) %>%
	addRasterImage(fut, colors = pal, opacity = 0.9, 
		group = "Projeção para 2080", maxBytes = Inf) %>%
	addLayersControl(overlayGroups = c("Presente", "Projeção para 2080"),
	                 options = layersControlOptions(collapsed = FALSE)) %>%
	addLegend(position = "bottomright", pal = pal, values = values(pre), 
	          title = "Riqueza") %>%
	addMeasure(position = "topleft", primaryLengthUnit = "kilometers")
m

# save the map
htmlwidgets::saveWidget(m, file = "riqueza.html")
