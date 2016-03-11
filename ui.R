
library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(dashboardHeader(title = "AutoDeskR"),
              dashboardSidebar(
                sidebarMenu(
                  menuItem("Map", tabName = "map", icon = icon("globe")),
                  menuItem("Drawing", tabName = "drawing", icon = icon("file-image-o"))
                  )
              ),
              dashboardBody(
                tabItems(
                  tabItem(tabName = "map",
                          fluidRow(
                            box(
                                leafletOutput("map")
                            )
                          )
                  ),
                  tabItem(tabName = "drawing",
                          fluidRow(
                            box(
                                htmlTemplate("template.html")
                            )
                          )
                  )
                )
              )
)