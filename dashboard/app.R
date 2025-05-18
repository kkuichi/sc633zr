library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
library(htmltools)
library(writexl)
library(gt)
library(DT)
library(plotly)
library(httr)
library(jsonlite)


shap_data <- read_csv("shap_values.csv", show_col_types = FALSE)  # Súbor s hodnotami SHAP z každej vlny pandémie

ui <- fluidPage(
  titlePanel("🏥 Vizuálna interpretácia modelu predikcie závažnosti priebehu COVID-19 pomocou SHAP"),
  
  
  tags$head(
    #Nastavenia štýlov
    tags$style(HTML("
      body {
        font-family: 'Segoe UI', sans-serif;
        background: linear-gradient(to right, #f4f4f4, #e9e7ef);
        color: #2c2c2c;
      }

.nav-tabs>li>a {
    background-color: transparent !important;
    color: #5b2c6f !important;
    border: 1px solid #d2b4de !important;
    border-bottom: none !important;
    margin-right: 5px;
    border-radius: 8px 8px 0 0 !important;
    font-weight: 500;
    padding: 10px 15px;
  }

 .nav-tabs>li.active>a,
  .nav-tabs>li.active>a:hover,
  .nav-tabs>li.active>a:focus {

    background-color: rgba(210, 180, 222, 0.2) !important;

    border: 1px solid #d2b4de !important;
    position: relative;
    z-index: 1;
  }


  .nav-tabs>li>a:hover {
    background-color: rgba(210, 180, 222, 0.2) !important;
    color: #4c1f66 !important;
  }

  .nav-tabs {
    border-bottom: 1px solid #d2b4de !important;
    padding-bottom: 1px;
  }



h2, h3 {
        color: #5b2c6f;
        text-align: left;
        margin-bottom: 20px;
      }

h4 {
        color: #3b3b3b;
        font-weight: bold;
        margin-top: 15px;
      }

p, ul {
        font-size: 16px;
        line-height: 1.6;
        color: #555;
      }

.wellPanel {
        background-color: #fff;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
      }
      
      
#shiny-tab-predikcia .sidebarPanel {
    width: 300px !important;  
    max-width: 100% !important;
    padding: 15px !important;
}
  
  #download_table, #download_excel, #download_plot,#download_shap_table_pred,#download_shap_plot_pred, #download_shap_excel_pred {
    background-color: #8e44ad !important;
    color: white !important;
    border: none !important;
    border-radius: 6px !important;
    padding: 8px 15px !important;
    margin-bottom: 10px !important;
    font-size: 14px !important;
    transition: all 0.3s ease !important;
    display: inline-block;
    text-align: center;
    white-space: normal; 
    word-wrap: break-word;
  }

  #download_table:hover, #download_excel:hover, #download_plot:hover ,#download_shap_table_pred:hover,#download_shap_plot_pred:hover, #download_shap_excel_pred:hover{
    background-color: #7d3c98 !important;
    transform: translateY(-1px) !important;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1) !important;
  }


  #download_table:active, #download_excel:active, #download_plot:active, #download_shap_table_pred:active,#download_shap_plot_pred:active, #download_shap_excel_pred:active {
    background-color: #6c3483 !important;
    transform: translateY(0) !important;
  }

  #predictButton {
     background-color: #6c3483 !important;
     color: white !important;
     border: none !important;
     border-radius: 6px !important;
     padding: 8px 15px !important;
     margin-bottom: 10px !important;
     font-size: 14px !important;
     transition: all 0.3s ease !important;
     
  }
   #predictButton:hover {
     background-color: #5b2c6f !important;
      transform: translateY(-1px) !important;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1) !important;
   }

  fa-download {
    margin-right: 5px !important;
  }


      .selectize-dropdown, .selectize-input {
        border-radius: 6px;
        border: 1px solid #6c3483;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }

      .tab-content > .tab-pane {
        transition: opacity 0.3s ease-in-out;
      }

      .highlight-box {
        background: #ffffff;
        border-radius: 10px;
        padding: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        margin-bottom: 30px;
      }
      
      #shiny-tab-predikcia .selectize-dropdown, 
      #shiny-tab-predikcia .selectize-input {
        min-height: 30px !important;
        padding: 5px 10px !important;
        font-size: 14px !important;
        border-color: #6c3483; 
        width: 80% !important; 
      }
      
      #shiny-tab-predikcia .highlight-box {
        background: #6c3483;
        border-radius: 8px;
        padding: 15px;
        box-shadow: 0 1px 5px rgba(0,0,0,0.05);
      }
      .custom-icon {
        color: #6c3483;
        margin-right: 8px;
      }

      .info-list li {
        margin-bottom: 8px;
      }

      .table th {
        background-color: #6c3483;
        color: #fff;
      }

      .slider-track, .slider .ui-slider-range {
        background: #6c3483 !important;
      }

      .slider-handle, .slider .ui-slider-handle {
        background: #9370DB !important;
        border: none !important;
      }


       .irs-bar {
    background: #9b59b6 !important;
    border-top: 1px solid #8e44ad !important;
    border-bottom: 1px solid #8e44ad !important;
  }

  .irs-bar-edge {
    background: #9b59b6 !important;
    border: 1px solid #8e44ad !important;
  }

  .irs-line {
    background: #e0d0e9 !important;
    border: 1px solid #d2b4de !important;
  }

  .irs-slider {
    background: #6c3483 !important;
    border: 1px solid #5b2c6f !important;
  }

  .irs-grid-text {
    color: #5b2c6f !important;
    font-size: 11px;
  }


  .irs-from, .irs-to, .irs-single {
    background: #6c3483 !important;
    color: white !important;
  }
  
  @media (max-width: 480px) {
 
  #download_table, #download_excel, #download_plot, #download_shap_table_pred, #download_shap_plot_pred {
    font-size: 11px !important; 
    padding: 4px 8px !important; 
  }
}
  
    "))
  ),
  
  
  tabsetPanel(
    tabPanel("Hlavná stránka",
             div(style = "max-width: 1100px; margin: 40px auto;",
                 div(class = "highlight-box",
                     h2("Vitajte!"),
                     p("Tento interaktívny dashboard bol vytvorený v rámci bakalárskej práce a slúži na zrozumiteľné vysvetlenie rozhodnutí prediktívneho modelu, ktorý predpovedá závažnosť priebehu ochorenia u pacientov s COVID-19.")
                 ),
                 
                 div(class = "highlight-box",
                     h3("🎯 Cieľ aplikácie"),
                     tags$ul(class = "info-list",
                             tags$li(icon("bullseye", class = "custom-icon"), "Poskytnúť prehľadné a interaktívne vizualizácie, ktoré pomôžu pochopiť fungovanie modelu."),
                             tags$li(icon("user-md", class = "custom-icon"), "Zvýšiť dôveru zdravotníckych pracovníkov pri rozhodovaní pomocou modelov."),
                             tags$li(icon("hospital", class = "custom-icon"), "Podporiť klinické rozhodovanie pri liečbe pacientov s COVID-19.")
                     )
                 ),
                 
                 div(class = "highlight-box",
                     h3("🧬 Ako model funguje?"),
                     h4("Prvá úroveň - Aké je riziko úmrtia pacienta?"),
                     tags$ul(
                       tags$li(icon("arrow-right", class = "custom-icon"), "0 = Pacient s vysokou pravdepodobnosťou prežije"),
                       tags$li(icon("arrow-right", class = "custom-icon"), "1 = Pacient vo vysokom riziku úmrtia")
                     ),
                     h4("Druhá úroveň (len pre preživších) - Aká bude závažnosť priebehu ochorenia?"),
                     tags$ul(
                       tags$li(icon("arrow-right", class = "custom-icon"), "0 = Stabilný stav - prepustenie do domácej liečby"),
                       tags$li(icon("arrow-right", class = "custom-icon"), "1 = Vyžaduje špecializovanú starostlivosť - preklad na oddelenie")
                     )
                 ),
                 
                 div(class = "highlight-box",
                     h3("💡Prečo SHAP?"),
                     p("SHAP (SHapley Additive exPlanations) je moderná metóda interpretácie strojového učenia, ktorá pomáha pochopiť, ako jednotlivé atribúty ovplyvňujú predikciu modelu. V podstate ide o „digitálneho konzultanta“, ktorý vysvetľuje, prečo sa model rozhodol tak, ako sa rozhodol – napríklad prečo odhadol vysoké riziko úmrtia u konkrétneho pacienta.")
                 ),
                 
                 div(class = "highlight-box",
                     h3("🛠 Ako používať túto aplikáciu?"),
                     tags$ul(class = "info-list",
                             tags$li("Prejdite na sekciu ", tags$b("„Popis dát“"),", kde nájdete štatistiky a popis použitých atribútov."),
                             tags$li("V časti ", tags$b("„Význam atribútov“"), " si môžete vybrať konkrétnu vlnu pandémie, typ modelu a zobraziť najvplyvnejšie faktory."),
                             tags$li("V časti", tags$b("„Predikcia“")," získate prognózu závažnosti ochorenia COVID-19 na základe zadaných hodnôt atribútov."),
                             tags$li("Použite tlačidlá na export grafov a tabuliek pre ďalšie použitie.")
                     )
                 ),
                 
                 div(class = "highlight-box",
                     h3("📝 Informácie o projekte"),
                     tags$ul(class = "info-list",
                             tags$li(tags$b("Názov práce:"), " Prognóza ochorenia COVID-19 pomocou dátovej analytiky"),
                             tags$li(tags$b("Autor:"), " Svitlana Chystiakova"),
                             tags$li(tags$b("Školiteľ:"), " prof. Ing. Ján Paralič, PhD"),
                             tags$li(tags$b("Konzultant:"), " Ing. Miroslava Matejová"),
                             tags$li(tags$b("Rok:"), " 2025")
                     )
                 )
             )
    ),
    
    
    tabPanel("Popis dát",
             div(class = "data-description-container",
                 style = "max-width: 1200px; margin: 0 auto; padding: 20px;",
                 
                 
                 div(class = "highlight-box",
                     h3("Popis dátového súboru", style = "color: #6c3483; border-bottom: 2px solid #d2b4de; padding-bottom: 10px;"),
                     
                     div(class = "wellPanel",
                         style = "background-color: #f9f9f9; border-radius: 8px; padding: 0px; margin-bottom: 5px;",
                         h4("Základné informácie", style = "color: #5b2c6f;"),
                         tags$ul(style = "list-style-type: none; padding-left: 0;",
                                 tags$li(icon("users", style = "color: #6c3483;"),
                                         HTML("<strong> Celkový počet pacientov:</strong> 3848"),
                                         tags$br()
                                 ),
                                 tags$li(icon("calendar-alt", style = "color: #6c3483;"),
                                         HTML("<strong> Obdobie zberu dát:</strong> 1. marec 2020 - 31. máj 2024"),
                                         tags$br()
                                 ),
                                 tags$li(icon("hospital", style = "color: #6c3483;"),
                                         HTML("<strong> Zdroj dát:</strong> Klinika infektológie a cestovnej medicíny (KICM) Univerzitnej nemocnice Louisa Pasteura (UNLP) v Košiciach")
                                 )
                         )
                     )
                 ),
                 
                 
                 fluidRow(
                   column(6,
                          div(class = "plot-container",
                              style = "background: white; border-radius: 8px; padding: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
                              h4("Rozdelenie tried po vlnách pandémie", style = "color: #5b2c6f;"),
                              plotlyOutput("wave_classification_plot", height = "400px")
                          )
                   ),
                   column(6,
                          div(class = "table-container",
                              style = "background: white; border-radius: 8px; padding: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 100%;",
                              h4("Prehľad atribútov", style = "color: #5b2c6f;"),
                              div(style = "max-height: 400px; overflow-y: auto;",
                                  DTOutput("data_structure_table")
                              )
                          )
                   )
                 ),
                 
                 hr(style = "border-top: 1px solid #d2b4de; margin: 20px 0;"),
                 
                 
                 fluidRow(
                   column(6,
                          div(class = "stats-container",
                              style = "background: white; border-radius: 8px; padding: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
                              h4("Štatistika vĺn pandémie", style = "color: #5b2c6f;"),
                              gt_output("wave_stats_table")
                          )
                   ),
                   column(6,
                          div(class = "variables-container",
                              style = "background: white; border-radius: 8px; padding: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 100%;",
                              h4("Kľúčové skupiny premenných", style = "color: #5b2c6f;"),
                              tags$ul(style = "list-style-type: none; padding-left: 0;",
                                      tags$li(
                                        icon("user-circle", style = "color: #6c3483;"),
                                        tags$strong("Demografické údaje:"),
                                        " Vek, Pohlavie, Fajčenie, Alkohol"
                                      ),
                                      tags$li(
                                        icon("heartbeat", style = "color: #6c3483;"),
                                        tags$strong("Komorbidity:"),
                                        " Hypertenzia, Diabetes mellitus, Kardiovaskulárne ochorenia, Chronické respiračné ochorenia, Renálne ochorenia, Pečeňové ochorenia, Onkologické ochorenia, Imunosupresia"
                                      ),
                                      tags$li(
                                        icon("bullseye", style = "color: #6c3483;"),
                                        tags$strong("Cieľové premenné:"),
                                        "Úroveň 'Úmrtnosť': 0=Prežil, 1=Zomrel; Úroveň 'Prežitie': 0=Prepustený do domáceho liečenia, 1=Preložený na iné oddelenie"
                                      )
                              )
                          )
                   )
                 )
             )
    ),
    
    
    tabPanel("Význam atribútov",
             br(),
             sidebarLayout(
               sidebarPanel(
                 width = 3,
                 style = "background-color: #f8f9fa; border-radius: 8px; padding: 20px;",
                 
                 selectInput("level", "Úroveň modelu:",
                             choices = c("Aké je riziko úmrtia pacienta?" = "mortality",
                                         "Aká bude závažnosť priebehu ochorenia (len pre preživších)?" = "severity"),
                 ),
                 
                 selectInput("wave", "Vlna pandémie:", choices = sort(unique(shap_data$wave))),
                 
                 sliderInput("top_n", "Počet zobrazených atribútov:",
                             min = 5, max = 12, value = 10),
                 
                 div(style = "margin-top: 30px;",
                     downloadButton("download_table", "Stiahnuť tabuľku (CSV)",
                                    style = "width: 100%; margin-bottom: 10px; background-color: #6c3483; color: white;"),
                     downloadButton("download_excel", "Stiahnuť tabuľku (Excel)",
                                    style = "width: 100%; margin-bottom: 10px; background-color: #6c3483; color: white;"),
                     downloadButton("download_plot", "Stiahnuť graf",
                                    style = "width: 100%; background-color: #6c3483; color: white;")
                 )
               ),
               
               mainPanel(
                 width = 9,
                 div(style = "background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
                     h4("Význam atribútov pre predikciu", style = "color: #5b2c6f; border-bottom: 2px solid #d2b4de; padding-bottom: 10px;"),
                     plotlyOutput("importance_plot", height = "450px")
                 ),
                 
                 div(style = "margin-top: 25px; background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
                     h4("Detailné SHAP hodnoty", style = "color: #5b2c6f; border-bottom: 2px solid #d2b4de; padding-bottom: 10px;"),
                     DTOutput("table_output")
                 ),
                 
                 div(style = "margin-top: 25px; background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
                     h4("Informácie o modeli", style = "color: #5b2c6f; border-bottom: 2px solid #d2b4de; padding-bottom: 10px;"),
                     uiOutput("model_info")
                 )
                 
               ))),
    
  
    
      tabPanel("Predikcia",
             br(),
             sidebarLayout(
               
               sidebarPanel(
                 width = 3,
                 numericInput("Vek", "Vek:", value = 50, min=0, max= 120),
                 selectInput("Pohlavie", "Pohlavie:", choices = c("Muž" = "Muž", "Žena" = "Žena")),
                 selectInput("Fajčenie", "Fajčenie:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Alkohol", "Alkohol:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Hypertenzia", "Hypertenzia:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Diabetes_mellitus", "Diabetes mellitus:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Kardiovaskulárne_ochorenia", "Kardiovaskulárne ochorenia:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Chronické_respiračné_ochorenia", "Chronické respiračné ochorenia:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Renálne_ochorenia", "Renálne ochorenia:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Pečeňové_ochorenia", "Pečeňové ochorenia:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Onkologické_ochorenia", "Onkologické ochorenia:", choices = c("Nie" = 0, "Áno" = 1)),
                 selectInput("Imunosupresia", "Imunosupresia:", choices = c("Nie" = 0, "Áno" = 1)),
                 actionButton("predictButton", "Získať prognózu", style = "margin-top: 20px; width: 100%; font-weight: bold;"), 
                 
                 div(style = "margin-top: 20px;", 
                     downloadButton("download_shap_excel_pred", "Stiahnuť tabuľku (Excel)", style = "width: 100%; margin-bottom: 10px;"),
                     downloadButton("download_shap_table_pred", "Stiahnuť tabuľku (CSV)", style = "width: 100%; margin-bottom: 10px;"), 
                     downloadButton("download_shap_plot_pred", "Stiahnuť graf (PNG)", style = "width: 100%;") 
                 )
               ),
               mainPanel(
                 width = 8,
                 div(class = "highlight-box", style=" font-weight: bold;font-size: 18px;", 
                     h3("Výsledok predikcie:", style = "color: #5b2c6f; border-bottom: 2px solid #d2b4de; padding-bottom: 10px; font-weight: bold;"),
                     
                     tags$p(textOutput("mortalityPrediction"), style=" font-weight: bold;"),
                     tags$p(textOutput("severityPrediction"), style=" font-weight: bold;")
                 ),
                 
                 div(class = "highlight-box", style = "margin-top: 25px;", 
                     h3("SHAP hodnoty pre tohto pacienta:", style = "color: #5b2c6f; border-bottom: 2px solid #d2b4de; padding-bottom: 10px; font-weight: bold;"),
                     selectInput("num_features_plot", "Počet zobrazených atribútov:", 
                                 choices = c(3, 6, 10, 12), selected = 6),
                     plotlyOutput("shapPlot")
                 ),
                 
                 div(class = "highlight-box", style = "margin-top: 25px;", 
                     uiOutput("shapExplanation"),
                     DTOutput("shapTable")
                 ),
                 div(
                   style = "margin-top: 25px; background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
                   h4("Informácie o modeli", style = "color: black !important; border-bottom: 2px solid #d2b4de; padding-bottom: 10px;"),
                   uiOutput("model_info_predict")
                 )
                 
               )
       )
    )
  )
)






server <- function(input, output, session) {
  

  calculated_data <- reactive({
    req(input$level, input$wave, input$top_n)
    
    
    # Filtrovanie a spracovanie údajov
    base_filtered <- shap_data %>%
      filter(level == input$level, wave == input$wave) %>%
      mutate(feature = ifelse(feature == "Pohlavie_Žena", "Pohlavie", feature))
    
    if (nrow(base_filtered) == 0) return(tibble())
    
    
    # Výpočet priemerných hodnôt SHAP
    summary_data <- base_filtered %>%
      group_by(feature) %>%
      summarise(
        mean_abs_shap = mean(abs(shap_value), na.rm = TRUE),
        mean_push_1 = mean(pmax(0, shap_value), na.rm = TRUE),
        mean_push_0 = abs(mean(pmin(0, shap_value), na.rm = TRUE)),
        .groups = "drop"
      ) %>%
      filter(!is.na(mean_abs_shap) & mean_abs_shap >= 0 & !is.nan(mean_abs_shap))
    
    top_features_data <- summary_data %>%
      arrange(desc(mean_abs_shap)) %>%
      slice_head(n = input$top_n)
    
    level_labels <- switch(input$level,
                           "mortality" = list(push1 = "Vplyv na úmrtie", push0 = "Vplyv na prežitie"),
                           "severity" = list(push1 = "Vplyv na preloženie na iné oddelenie", push0 = "Vplyv na prepustenie na domácu liečbu"),
                           list(push1 = "Avg. SHAP -> Trieda 1", push0 = "Avg. SHAP -> Trieda 0")
    )
    
    top_features_data %>%
      rename(
        `Atribút` = feature,
        `Celkový vplyv` = mean_abs_shap,
        !!level_labels$push1 := mean_push_1,
        !!level_labels$push0 := mean_push_0
      ) %>%
      select(`Atribút`, `Celkový vplyv`, !!level_labels$push0, !!level_labels$push1)
  })
  
  plot_data_simple <- reactive({
    df <- calculated_data()
    req(nrow(df) > 0)
    df %>%
      select(`Atribút`, `Celkový vplyv`) %>%
      mutate(`Atribút` = factor(`Atribút`, levels = rev(`Atribút`)))
  })
  
  
  # SHAP plot
  output$importance_plot <- renderPlotly({
    plot_df <- plot_data_simple()
    req(nrow(plot_df) > 0)
    
    p <- ggplot(plot_df, aes(x = `Celkový vplyv`, y = `Atribút`)) +
      geom_col(aes(fill = `Celkový vplyv`)) +
      scale_fill_gradient(low = "#d2b4de", high = "#6c3483", guide = "none") +
      labs(
        title = paste("Top", input$top_n, "najdôležitejších príznakov"),
        subtitle = paste("Úroveň modelu:", input$level, "| Vlna:", input$wave),
        x = "", y = ""
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 14),
        plot.subtitle = element_text(hjust = 0.5, size = 12),
        axis.text.y = element_text(margin = margin(r = 10))
      )
    
    ggplotly(p, tooltip = c("y", "x")) %>%
      layout(
        margin = list(l = 120, r = 20, t = 80, b = 60),
        yaxis = list(title = list(text = "Príznaky", standoff = 20))
      )
  })
  
  
  # Reaktívny výpočet na zobrazenie intervalov hodnôt SHAP
  full_calculated_data <- reactive({
    req(input$level, input$wave)
    
    base_filtered <- shap_data %>%
      filter(level == input$level, wave == input$wave) %>%
      mutate(feature = ifelse(feature == "Pohlavie_Žena", "Pohlavie", feature))
    
    if (nrow(base_filtered) == 0) return(tibble())
    
    summary_data <- base_filtered %>%
      group_by(feature) %>%
      summarise(
        mean_abs_shap = mean(abs(shap_value), na.rm = TRUE),
        mean_push_1 = mean(pmax(0, shap_value), na.rm = TRUE),
        mean_push_0 = abs(mean(pmin(0, shap_value), na.rm = TRUE)),
        .groups = "drop"
      ) %>%
      filter(!is.na(mean_abs_shap) & mean_abs_shap >= 0 & !is.nan(mean_abs_shap))
    
    level_labels <- switch(input$level,
                           "mortality" = list(push1 = "Vplyv na úmrtie", push0 = "Vplyv na prežitie"),
                           "severity" = list(push1 = "Vplyv na preloženie na iné oddelenie", push0 = "Vplyv na prepustenie na domácu liečbu"),
                           list(push1 = "Avg. SHAP -> Trieda 1", push0 = "Avg. SHAP -> Trieda 0")
    )
    
    summary_data %>%
      rename(
        `Atribút` = feature,
        `Celkový vplyv` = mean_abs_shap,
        !!level_labels$push1 := mean_push_1,
        !!level_labels$push0 := mean_push_0
      ) %>%
      select(`Atribút`, `Celkový vplyv`, !!level_labels$push0, !!level_labels$push1)
  })
  
  
  
  # Výsledná tabuľka SHAP
  output$table_output <- renderDT({
    df <- calculated_data()
    full_df <- full_calculated_data()  
    req(nrow(df) > 0)
    
    current_level <- input$level
    col_name_0 <- names(df)[3]
    col_name_1 <- names(df)[4]
    df$highlight_column <- ifelse(df[[col_name_0]] > df[[col_name_1]], "left", "right")
    
    explanation_0 <- switch(current_level,
                            "mortality" = "Ako parameter zvyšuje pravdepodobnosť prežitia (čím vyššia hodnota, tým väčší vplyv).",
                            "severity" = "Ako parameter zvyšuje pravdepodobnosť prepustenia pacienta do domácej liečby (čím vyššia hodnota, tým väčší vplyv)."
    )
    
    explanation_1 <- switch(current_level,
                            "mortality" = "Ako parameter zvyšuje pravdepodobnosť úmrtia (čím vyššia hodnota, tým vyššie riziko).",
                            "severity" = "Ako parameter zvyšuje pravdepodobnosť preloženia pacienta na iné oddelenie (čím vyššia hodnota, tým vyššie riziko)."
    )
    
  
    col_celk <- names(full_df)[2]
    col_lvl_0 <- names(full_df)[3]
    col_lvl_1 <- names(full_df)[4]
    
    min_celk <- round(min(full_df[[col_celk]], na.rm = TRUE), 4)
    max_celk <- round(max(full_df[[col_celk]], na.rm = TRUE), 4)
    
    min_lvl_0 <- round(min(full_df[[col_lvl_0]], na.rm = TRUE), 4)
    max_lvl_0 <- round(max(full_df[[col_lvl_0]], na.rm = TRUE), 4)
    
    min_lvl_1 <- round(min(full_df[[col_lvl_1]], na.rm = TRUE), 4)
    max_lvl_1 <- round(max(full_df[[col_lvl_1]], na.rm = TRUE), 4)
    
    datatable(
      df,
      options = list(
        pageLength = 12,
        order = list(1, 'desc'),
        searching = TRUE,
        lengthChange = TRUE,
        dom = 't',
        columnDefs = list(
          list(visible = FALSE, targets = 4)
        ),
        scrollX = TRUE
      ),
      rownames = FALSE,
      
      caption = tags$caption(
        style = 'caption-side: top; text-align: left; margin-bottom: 10px;',
        tags$div(
          style = '
        background-color: #f0f0f0;
        padding: 10px;
        border-left: 6px solid #6c3483;
        border-radius: 4px;
        font-size: 16px;
        color: #2c3e50;
        font-weight: bold;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
      ',
          tags$span("📌 Vysvetlenia k tabuľke:")
        ),
        tags$ul(
          style = 'margin-left: 15px;',
          tags$li(
            tags$strong("Atribút:"), " Názov vstupného príznaku modelu."
          ),
          tags$li(
            tags$strong("Celkový vplyv:"), 
            " Aká veľká je celková dôležitosť atribútu pre model (bez ohľadu na smer vplyvu). ",
            tags$em(paste0("Interval od ", min_celk, " do ", max_celk, "."))
          ),
          tags$li(
            tags$strong(col_lvl_0), 
            paste0(explanation_0, " "),
            tags$em(paste0("Interval od ", min_lvl_0, " do ", max_lvl_0, "."))
          ),
          tags$li(
            tags$strong(col_lvl_1), 
            paste0(explanation_1, " "),
            tags$em(paste0("Interval od ", min_lvl_1, " do ", max_lvl_1, "."))
          )
        )
      )
    ) %>%
      formatRound(columns = c(2, 3, 4), digits = 4) %>%
      formatStyle(
        columns = col_name_0,
        valueColumns = 'highlight_column',
        backgroundColor = styleEqual(
          c("left", "right"),
          c("#d9ead3", NA)  
        )
      ) %>%
      formatStyle(
        columns = col_name_1,
        valueColumns = 'highlight_column',
        backgroundColor = styleEqual(
          c("left", "right"),
          c(NA, "#f4cccc")  
        )
      )
  })
  
  
  
  
  
  # Downloady
  output$download_table <- downloadHandler(
    filename = function() {
      paste0("shap_summary_", input$level, "_", input$wave, "_top", input$top_n, ".csv")
    },
    content = function(file) {
      write.csv(calculated_data(), file, row.names = FALSE, fileEncoding = "UTF-8")
    }
  )
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste0("shap_summary_", input$level, "_", input$wave, "_top", input$top_n, ".xlsx")
    },
    content = function(file) {
      write_xlsx(calculated_data(), path = file)
    }
  )
  
  output$download_plot <- downloadHandler(
    filename = function() {
      paste0("shap_plot_", input$level, "_", input$wave, "_top", input$top_n, ".png")
    },
    content = function(file) {
      ggsave(file,
             plot = ggplot(plot_data_simple(), aes(x = `Priemerná SHAP hodnota`, y = `Atribút`)) +
               geom_col(aes(fill = `Priemerná SHAP hodnota`)) +
               scale_fill_gradient(low = "#d2b4de", high = "#6c3483", guide = "none") +
               theme_minimal(),
             width = 10, height = 6, dpi = 300
      )
    }
  )
  output$download_shap_table_pred <- downloadHandler(
    filename = function() {
      paste0("shap_pred_table_", Sys.Date(), ".csv")
    },
    content = function(file) {
      req(result_vals$shap)
      
      shap_vals <- unname(unlist(result_vals$shap))
      if (!is.null(result_vals$severity) && result_vals$severity == 0) {
        shap_vals <- -shap_vals
      }
      
      shap_df <- data.frame(
        Feature = names(result_vals$shap),
        Contribution = shap_vals
      )
      shap_df$Feature <- ifelse(shap_df$Feature == "Pohlavie_Žena", "Pohlavie", shap_df$Feature)
      
      write.csv(shap_df, file, row.names = FALSE, fileEncoding = "UTF-8")
    }
  )
  
  
  output$download_shap_excel_pred <- downloadHandler(
    filename = function() {
      paste0("shap_pred_table_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      req(result_vals$shap)
      
      shap_vals <- unname(unlist(result_vals$shap))
     
      if (!is.null(result_vals$severity) && result_vals$severity == 0) {
        shap_vals <- -shap_vals
      }
      
      shap_df <- data.frame(
        Feature = names(result_vals$shap),
        Contribution = shap_vals
      )
      shap_df$Feature <- ifelse(shap_df$Feature == "Pohlavie_Žena", "Pohlavie", shap_df$Feature)
      
      writexl::write_xlsx(shap_df, path = file)
    }
  )
  
  
  output$download_shap_plot_pred <- downloadHandler(
    filename = function() {
      paste0("shap_pred_plot_", Sys.Date(), ".png")
    },
    content = function(file) {
      req(result_vals$shap)
      shap_df <- data.frame(
        Feature = names(result_vals$shap),
        Contribution = abs(unlist(result_vals$shap))
      )
      shap_df$Feature <- ifelse(shap_df$Feature == "Pohlavie_Žena", "Pohlavie", shap_df$Feature)
      
      shap_df <- shap_df[order(shap_df$Contribution, decreasing = TRUE), ]
      
      p <- ggplot(shap_df, aes(x = Contribution, y = reorder(Feature, Contribution))) +
        geom_col(aes(fill = Contribution)) +
        scale_fill_gradient(low = "#d2b4de", high = "#6c3483", guide = "none") +
        labs(
          title = paste("Význam atribútov pre predikciu"),
          x = "",
          y = ""
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(hjust = 0.5, size = 14),
          axis.text.y = element_text(size = 12),
          axis.text.x = element_text(size = 12)
        )
      
      ggsave(file, plot = p, width = 10, height = 6, dpi = 300)
    }
  )
  
  # Informácie o modeloch
  
  model_metrics <- reactive({
    req(input$wave)
    
    metrics <- switch(input$wave,
                      "1" = list(
                        model = "XGBoost",
                        h_precision = 0.7875,
                        h_recall = 0.8097,
                        h_fscore = 0.7984,
                        description = "Model pre prvú vlnu (Wuhan) bol vytvorený s využitím algoritmu XGBoost."
                      ),
                      "2" = list(
                        model = "Logistická regresia",
                        h_precision = 0.8147,
                        h_recall = 0.8621,
                        h_fscore = 0.8377,
                        description = "Model pre druhú vlnu (Alfa) bol vytvorený s využitím algoritmu Logistická regresia."
                      ),
                      "3" = list(
                        model = "SVM",
                        h_precision = 0.8017,
                        h_recall = 0.7886,
                        h_fscore = 0.7951,
                        description = "Model pre tretiu vlnu (Delta) bol vytvorený s využitím algoritmu SVM (metóda podporných vektorov)."
                      ),
                      "4" = list(
                        model = "Logistická regresia",
                        h_precision = 0.8096,
                        h_recall = 0.8395,
                        h_fscore = 0.8243,
                        description = "Model pre štvrtú vlnu (Omikron) bol vytvorený s využitím algoritmu Logistická regresia.."
                      )
    )
    stopifnot(
      is.numeric(metrics$h_precision),
      is.numeric(metrics$h_recall),
      is.numeric(metrics$h_fscore)
    )
    return(metrics)
  })
  
  # Metriky modelu
  output$model_info <- renderUI({
    metrics <- model_metrics()
    
    tagList(
      tags$p(style = "font-weight: bold;", metrics$description),
      tags$table(
        class = "table",
        style = "width: 100%; margin-top: 15px;",
        tags$thead(
          tags$tr(
            tags$th("Model"),
            tags$th("h-Presnosť"),
            tags$th("h-Recall"),
            tags$th("h-F-score")
          )
        ),
        tags$tbody(
          tags$tr(
            tags$td(metrics$model),
            tags$td(round(metrics$h_precision, 4)),
            tags$td(round(metrics$h_recall, 4)),
            tags$td(round(metrics$h_fscore, 4))
          )
        )
      ),
      tags$div(
        style = "background-color: #f8f9fa; padding: 10px; border-radius: 5px; margin-top: 15px;",
        tags$p(style = "font-weight: bold;", "📌 Vysvetlivky k tabuľke:"),
        tags$ul(
          style = "margin-left: 15px;",
          tags$li(tags$strong("h-Presnosť:"), " Aký podiel pacientov, ktorých model označil ako rizikových, boli skutočne rizikoví."),
          tags$li(tags$strong("h-Recall:"), " Aký podiel skutočne rizikových pacientov model správne identifikoval."),
          tags$li(tags$strong("h-F-score:"), " Celkové zhodnotenie výkonnosti modelu – berie do úvahy presnosť (Precision) aj návratnosť (Recall)."),
          tags$li(tags$strong("Všetky uvedené metriky nadobúdajú hodnoty v intervale od 0 do 1, pričom hodnota 1 predstavuje ideálny výkon modelu.") )
        )
        
      )
    )
    
  })
  
  
  
  
  # Ostatné vizualizácie (popis dat)
  #Graf počtu pacientov v jednotlivých vlnách
  output$wave_classification_plot <- renderPlotly({
    wave_class_data <- data.frame(
      Vlna = rep(c("1. vlna", "2. vlna", "3. vlna", "4. vlna"), each = 3),
      Kategória = rep(c("Zomrel", "Prepustený do domáceho liečenia", "Preložený na iné oddelenie"), 4),
      Počet = c(132, 711, 281, 107, 568, 149, 70, 448, 131, 128, 907, 213)
    )
    
    colors <- c(
      "Zomrel" = "#e67e7e",
      "Prepustený do domáceho liečenia" = "#7eb0e6",
      "Preložený na iné oddelenie" = "#a5e67e"
    )
    
    fig <- plot_ly(
      data = wave_class_data,
      x = ~Vlna,
      y = ~Počet,
      color = ~Kategória,
      colors = colors,
      type = 'bar',
      text = ~paste(Kategória, "<br>Počet:", Počet),
      hoverinfo = 'text',
      textposition = 'none',
      texttemplate = '',
      marker = list(line = list(width = 1, color = 'rgba(0,0,0,0.1)'))
    ) %>%
      layout(
        barmode = 'group',
        showlegend = TRUE,
        xaxis = list(title = "Vlna pandémie", showgrid = FALSE, fixedrange = TRUE),
        yaxis = list(title = "Počet pacientov", gridcolor = '#f0f0f0', fixedrange = TRUE),
        legend = list(
          title = list(text = "<b>Kategória pacientov</b>"),
          orientation = "h", x = 0.5, xanchor = "center", y = -0.3
        ),
        hovermode = 'closest',
        plot_bgcolor = 'rgba(0,0,0,0)',
        paper_bgcolor = 'rgba(0,0,0,0)',
        margin = list(l = 50, r = 20, t = 20, b = 100)
      ) %>%
      return(fig)
    
  })
  
  
  # Statistika vĺn
  output$wave_stats_table <- render_gt({
    wave_data <- data.frame(
      Vlna = c("1. vlna (Wuhan)", "2. vlna (Alpha)", "3. vlna (Delta)", "4. vlna (Omicron)"),
      Obdobie = c("03/2020 - 02/2021", "03/2021 - 08/2021", "09/2021 - 12/2021", "01/2022 - 05/2024"),
      Pocet = c(1124, 824, 649, 1248)
    )
    
    wave_data %>%
      gt() %>%
      cols_label(Vlna = "Vlna pandémie", Obdobie = "Obdobie", Pocet = "Počet pacientov") %>%
      tab_style(
        style = list(cell_text(color = "white", weight = "bold"), cell_fill(color = "#6c3483")),
        locations = cells_column_labels()
      ) %>%
      tab_style(
        style = cell_borders(sides = c("left", "right", "bottom"), color = "#f0f0f0", weight = px(1)),
        locations = cells_body()
      ) %>%
      tab_options(
        table.width = pct(100), table.font.size = px(14), data_row.padding = px(8),
        table_body.hlines.color = "transparent", column_labels.border.top.width = px(3),
        column_labels.border.top.color = "#6c3483"
      ) %>%
      cols_align(align = "left", columns = c(Vlna, Obdobie)) %>%
      cols_align(align = "center", columns = Pocet) %>%
      fmt_number(columns = Pocet, decimals = 0, use_seps = FALSE)
  })
  
  
  # Štruktúra vstupných dát
  output$data_structure_table <- renderDT({
    df <- data.frame(
      Atribút = c("Vek", "Pohlavie", "Fajčenie", "Alkohol", "Hypertenzia",
                  "Diabetes Mellitus", "Kardiovaskulárne ochorenie", "Chronické respiračné ochorenie",
                  "Renálne ochorenia", "Pečeňové ochorenia", "Onkologické ochorenia",
                  "Imunosupresia", "Závažnosť priebehu ochorenia"),
      Typ = c("Numerický", "Kategorický", "Binárny", "Binárny", "Binárny",
              "Binárny", "Binárny", "Binárny", "Binárny", "Binárny", "Binárny",
              "Binárny", "Kategorický"),
      Popis = c("Vek pacienta v rokoch", "0/1, (Žena/Muž)", "0/1, (Nie/Áno)", "0/1, (Nie/Áno)",
                "0/1, (Nie/Áno)", "0/1, (Nie/Áno)", "0/1, (Nie/Áno)", "0/1, (Nie/Áno)",
                "0/1, (Nie/Áno)", "0/1, (Nie/Áno)", "0/1, (Nie/Áno)", "0/1, (Nie/Áno)",
                "1=Prepustený do domáceho liečenia, 2=Preložený na iné oddelenie, 3=Zomrel")
    )
    
    datatable(
      df,
      options = list(scrollY = "350px", paging = FALSE, dom = 't'),
      rownames = FALSE
    )
    
    
  })
  
  

 #Záložka predikcie
  
  result_vals <- reactiveValues(mortality = NULL, severity = NULL, shap = NULL, error = NULL)
  
    observeEvent(input$predictButton, {
      patient_data <- list(
        Vek = as.numeric(input$Vek),
        Pohlavie_Žena = input$Pohlavie,
        Fajčenie = as.numeric(input$Fajčenie),
        Alkohol = as.numeric(input$Alkohol),
        "Hypertenzia" = as.numeric(input$Hypertenzia),
        "Diabetes mellitus" = as.numeric(input$Diabetes_mellitus),
        "Kardiovaskulárne ochorenia" = as.numeric(input$Kardiovaskulárne_ochorenia),
        "Chronické respiračné ochorenia" = as.numeric(input$Chronické_respiračné_ochorenia),
        "Renálne ochorenia" = as.numeric(input$Renálne_ochorenia),
        "Pečeňové ochorenia" = as.numeric(input$Pečeňové_ochorenia),
        "Onkologické ochorenia" = as.numeric(input$Onkologické_ochorenia),
        "Imunosupresia" = as.numeric(input$Imunosupresia)
      )
      
      res <- httr::POST(
        url = "https://jupyterproject3-production.up.railway.app/predict",
        body = jsonlite::toJSON(patient_data, auto_unbox = TRUE),
        encode = "json",
        httr::add_headers("Content-Type" = "application/json")
      )
      
      if (res$status_code == 200) {
        result <- httr::content(res)
        result_vals$mortality <- result$mortality_prediction
        result_vals$severity <- result$severity_prediction
        result_vals$shap <- result$shap_values
        result_vals$error <- NULL
      } else {
        result_vals$mortality <- NULL
        result_vals$severity <- NULL
        result_vals$shap <- NULL
        result_vals$error <- "❌ Chyba pri predikcii."
      }
    })
    
    output$mortalityPrediction <- renderText({
      if (!is.null(result_vals$error)) {
        return(result_vals$error)
      }
      if (is.null(result_vals$mortality)) return("")
      if (result_vals$mortality == 1) {
        "⚠️ Vysoké riziko úmrtia."
      } else{
        "✅Vysoká pravdepodobnosť prežitia"
      }
    })
    
    output$severityPrediction <- renderText({
      if (!is.null(result_vals$severity)) {
        if (result_vals$severity == 0) {
          "🏠 Odporúčaná domáca liečba."
        } else {
          "🏥 Odporúčaná hospitalizácia na iné oddelenie."
        }
      } else {
        ""
      }
    })
    
    
# Vysvetlenie hodnôt SHAP (predikcia)
    output$shapExplanation <- renderUI({
      req(result_vals$mortality)
      if (!is.null(result_vals$error)) return(NULL)
      
      explanation_text <- NULL
      
      if (result_vals$mortality == 1) {
        explanation_text <- "Kladné hodnoty zvyšujú riziko úmrtia, záporné hodnoty ho znižujú."
      } else if (!is.null(result_vals$severity)) {
        if (result_vals$severity == 0) {
          explanation_text <- "Kladné hodnoty zvyšujú pravdepodobnosť domácej liečby, záporné hodnoty ju znižujú."
        } else if (result_vals$severity == 1) {
          explanation_text <- "Kladné hodnoty zvyšujú pravdepodobnosť potreby hospitalizácie, záporné hodnoty ju znižujú."
        }
      }
      
      if (is.null(explanation_text)) return(NULL)
      
      
      shap_vals <- unname(unlist(result_vals$shap))
            if (!is.null(result_vals$severity) && result_vals$severity == 0) {
        shap_vals <- -shap_vals
      }
      
      min_val <- round(min(shap_vals), 2)
      max_val <- round(max(shap_vals), 2)
      
      interval_text <- sprintf(
        "<br>Hodnoty SHAP pre tohto pacienta sa pohybujú v intervale od <strong>%.2f</strong> do <strong>%.2f</strong>.",
        min_val, max_val
      )
      
      full_text <- paste0(explanation_text, interval_text)
      
      
      
      tags$div(
        style = '
      background-color: #f0f0f0;
      padding: 10px;
      border-left: 6px solid #6c3483;
      border-radius: 4px;
      font-size: 16px;
      color: #2c3e50;
      margin-bottom: 12px;
    ',
        tags$strong("📌 Vysvetlenia k tabuľke: "),
        HTML(full_text)
      )
    })
    
    
# Tabuľka s hodnotami SHAP pacienta
    output$shapTable <- DT::renderDT({
      req(result_vals$shap)
      shap_vals <- unname(unlist(result_vals$shap))
      
      if (!is.null(result_vals$severity) && result_vals$severity == 0) {
        shap_vals <- -shap_vals
      }
      
      shap_df <- data.frame(
        Atribút = names(result_vals$shap),
        Príspevok = round(shap_vals,2)
      )
      
      shap_df$Atribút <- ifelse(shap_df$Atribút == "Pohlavie_Žena", "Pohlavie", shap_df$Atribút)
      
      shap_df <- shap_df[order(-abs(shap_df$Príspevok)), ]
      
      shap_df <- head(shap_df, as.numeric(input$num_features_plot))
      
      DT::datatable(
        shap_df,
        rownames = FALSE,
        options = list(
          dom = 't',
          scrollX = "300px",    
          scrollY = FALSE,  
          scrollCollapse = TRUE,
          paging = FALSE,
          info = ""
        )
      )
    })
    
    
# Graf s hodnotami SHAP pacienta
  
    output$shapPlot <- renderPlotly({
      req(result_vals$shap)
      req(input$num_features_plot)
      
      shap_df <- data.frame(
        Feature = names(result_vals$shap),
        Contribution = abs(unlist(result_vals$shap)) 
      )
      
      shap_df$Feature <- ifelse(shap_df$Feature == "Pohlavie_Žena", "Pohlavie", shap_df$Feature)
      
      shap_df <- shap_df[order(shap_df$Contribution, decreasing = TRUE), ]
      shap_df <- head(shap_df, as.numeric(input$num_features_plot))
      
      p <- ggplot(shap_df, aes(x = Contribution, y = reorder(Feature, Contribution))) +
        geom_col(aes(fill = Contribution)) +  
        scale_fill_gradient(low = "#d2b4de", high = "#6c3483", guide = "none") +
        labs(
          title = "Význam atribútov pre predikciu",
          x = "",
          y = ""
        ) +
        theme_minimal(base_size = 12) +
        theme(
          plot.title = element_text(hjust = 0.5, size = 14),
          axis.text.y = element_text(size = 12),
          plot.margin = margin(t = 30, r = 30, b = 60, l = 30)
        )
      
      ggplotly(p, tooltip = c("x", "y")) %>%
        layout(
          margin = list(l = 220, r = 40, t = 60, b = 60),
          yaxis = list(
            title = "",
            tickfont = list(size = 12),
            ticklabelposition = "outside",
            ticklabelstep = 1,
            tickangle = 0,
            automargin = TRUE,
            standoff = 20  
          ),
          xaxis = list(
            range = c(0, max(shap_df$Contribution) * 1.1)
          )
        )
    })

    # Opis použitého algoritmu
    output$model_info_predict <- renderUI({
      HTML("
    <p style='color: black; font-weight: bold;'>Na trénovanie modelu boli použité dáta zo štvrtej vlny pandémie COVID-19, ktoré sú najaktuálnejšie k dnešnému dňu.</p>

  ")
    })
    

}

shinyApp(ui = ui, server = server)