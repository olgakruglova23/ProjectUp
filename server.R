library(shiny)
library(ggplot2)
library(markdown)


shinyServer(function(input, output) {
        
        dataSet <- reactive({
                data <- movies[, -c(7:16)]
                
                data <- data[data$rating >= input$rating[1] & data$rating <= input$rating[2], ]
                
                
                data <- data[data$year >= input$year[1] & data$year<= input$year[2], ]
                data <- data[order(data$year), ]
                if(input$genre != "All"){
                        data <- data[data[ , input$genre] == "1", ]
                }
                
                
                data
        })
        output$table <- renderDataTable({
                dataSet()
        })
        
        output$bar <- renderPlot({
                
                count <- sapply(dataSet()[, c(8:14)], function(x) {length(which(x == "1"))})
                countY <- data.frame(count)
                countY$genre <- rownames(countY)
                p <- ggplot(countY, aes(x = genre, y = count))
                p <- p + geom_bar(stat = "identity")
                p <- p + ggtitle("Genres on IMDB by year and rating")
                p <- p + theme(text = element_text(size = 18), plot.title = element_text(size=18, face = "bold"), 
                               axis.title=element_text(size=16,face="bold"))
                print(p)
        }, width = 900)
        
        output$text <- renderText({
               
                paste("10 films with the highest votes:")
                
        })
        
        output$table10 <- renderDataTable({
                ordered <- dataSet()[order(-dataSet()$votes), ]
                top10 <- ordered[1:10, -7]
                top10
        })
        
        output$downloadData <- downloadHandler(
                filename = "films.csv",
                content = function(file){
                        write.csv(dataSet(), file)
                }
                )
})