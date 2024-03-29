---
title: "STAT308_Research_Project"
author: "Elijah Wooten"
date: "4/1/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
food = read.csv("Food_Supply_Quantity_kg_Data.csv")
head(food)
attach(food)
food
```

```{r}
#Best Model AIC

#Linear model of all predictors except obesity
food_model <- lm(Confirmed ~ Alcoholic.Beverages + Animal.fats + Animal.Products + Aquatic.Products..Other + Cereals...Excluding.Beer + Eggs + Fish..Seafood + Fruits...Excluding.Wine + Meat + Milk...Excluding.Butter + Miscellaneous + Offals + Oilcrops + Pulses + Spices + Starchy.Roots + Stimulants + Sugar...Sweeteners + Sugar.Crops + Treenuts + Vegetable.Oils + Vegetables + Vegetal.Products + Recovered + Deaths + Population, data = food)
```

```{r}
summary(food_model)
par(mfrow=c(2, 2))
plot(food_model)
removedquantitativedata <- subset(food, select = -c(Country, Unit..all.except.Population., Undernourished, Miscellaneous, Obesity, Confirmed, Deaths, Recovered, Active, Population))
removedquantitativedata
cor(removedquantitativedata)
pairs(removedquantitativedata)
```

```{r}
#Creates initial linear model on food$Confirmed
model0 <- lm(food$Confirmed ~ 1)

#AIC using all predictors except obesity
library(MASS)
step1 <- stepAIC(model0, scope = list(lower = model0, upper = food_model), direction = "forward")
```

```{r}
#Best Model AIC #2

library(car)

#Creates best model from AIC
best_model <- lm(Confirmed ~ Deaths + Recovered + Vegetal.Products + Offals + Animal.Products, data = food)

#Runs anova of our best model compared with the model with all predictors
anova(best_model, food_model)
```

```{r}
#Best Model Diagnostics

#R^2 of best_model vs. with all predictors
summary(best_model)$adj.r.squared
summary(food_model)$adj.r.squared
```

```{r}
#Best Model Diagnostics #2

#Residuals plot of the best model
res <- residuals(best_model)
plot(fitted(best_model), res)

#Test for constant variance
library(lmtest)

bptest(best_model)
```

```{r}
#Best Model Diagnostics #3

#Test for normality of best model
qqPlot(best_model, main = "QQ Plot")

library(nortest)

shapiro.test(best_model$residuals)
```

```{r}
#Best Model Diagnostics #4

#Test for severe multicollinearity
vif(best_model)
```

```{r}
#Best Model Diagnostics #5

# Find Outlier 
rs = rstudent(best_model) #Jackknife Residuals
which(rs >= 3)

# Find High leverage
Lev = lm.influence(best_model)$hat
sort(Lev, decreasing = T)[1:10]
```

```{r}
#Obesity and Malnourished Model

ob_un <- lm(Confirmed ~ Obesity + Undernourished2, data = food)
ob <- lm(Confirmed ~ Obesity, data = food)
un <- lm(Confirmed ~ Undernourished2, data = food)
anova(ob)
anova(un)
anova(ob_un)
```

```{r}
#Obesity and Malnourished Model #2

#testing for interaction between obesity and undernourished
interaction <- lm(Confirmed ~ Obesity + Undernourished2 + Obesity*Undernourished2, data = food)
anova(interaction)
```

```{r}
#Obesity and Malnourished Model #3

#R^2 of obesity and malnourished vs. best model and all predictors
summary(ob_un)$adj.r.squared
summary(best_model)$adj.r.squared
summary(food_model)$adj.r.squared
```

```{r}
#Obesity and Malnourished Model #4

#Residuals plot of the obesity and undernourished model
res <- residuals(ob_un)
plot(fitted(ob_un), res)

#Test for constant variance
library(lmtest)

bptest(ob_un)

summary(best_model)
```

```{r}
#Obesity and Malnourished Model #5

#Test for normality of obesity and malnourished model
qqPlot(ob_un, main = "QQ Plot")

library(nortest)

shapiro.test(ob_un$residuals)
```

```{r}
#Obesity and Malnourished Model #6

#Test for severe multicollinearity
vif(ob_un)
```

```{r}
#Obesity and Malnourished Model #7

# Find Outlier 
rs = rstudent(ob_un) #Jackknife Residuals
which(rs >= 3)

# Find High leverage
Lev = lm.influence(ob_un)$hat
sort(Lev, decreasing = T)[1:10]
```

```{r}
#Obesity and Malnourished Model #8

plot(food$Undernourished2, food$Confirmed, xlab = "Undernourishment Rate", ylab = "Confirmed COVID Case Rate")

abline(lm(food$Confirmed ~ food$Undernourished2))
```

```{r}
#Obesity and Malnourished Model #9

plot(food$Obesity, food$Confirmed, xlab = "Obesity Rate", ylab = "Confirmed COVID Case Rate")

abline(lm(food$Confirmed ~ food$Obesity))
```
