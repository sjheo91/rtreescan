
#' Transpose the data
#' 
#' @description
#' A function that converts data to return a tree structure and a count data structure.
#'
#' @details
#' A function that converts data to return a tree structure and a count data structure.
#'
#'
#' @param AE_code Code for Adverse Event 
#' @param drug_code Name for Drug or Vaccine etc.
#' @param model Interger for probability model type (POISSON=0, BERNOULLI=1)
#' @param condition Interger for conditional type (UNCONDITIONAL=0, TOTALCASES=1)
#' @param rate Numeric indicating expected probability for unconditional type 
#' @param match_vars The variables you want to use for matching.
#' @param N matching ratio
#' @export

ts_data <- function(data, AE_code, drug_code, case, control, lv_sep, model, condition, rate, match_vars, N, Start, End, match){
  # library(stringr)
  str_loc <- function(string, lv_sep){
    loc_all <- str_locate_all(string=string, pattern=lv_sep)
    str_loc_list <- list()
    for(i in 1:length(loc_all)){
      str_loc_list[[i]] <- loc_all[[i]][,1]
    }
    return(str_loc_list)
  }
  
  # Make a Tree
  tre_pros <- function(data, AE_code, drug_code, lv_sep){
    n <- xtabs(~get(AE_code)+get(drug_code), data)
    n <- n[apply(n,1,sum)!=0,apply(n,2,sum)!=0]
    
    node_list <- row.names(n)
    lv_sep_loc <- str_loc(string=node_list, lv_sep=lv_sep)
    
    num_lv <- length(lv_sep_loc[[1]])+1
    
    for(i in 1:num_lv){
      if(i!=1){
        sep_node <- sapply(lv_sep_loc,"[[",num_lv-i+1)
      }
      if(i!=num_lv){
        sep_parent <- sapply(lv_sep_loc,"[[",num_lv-i)
      }
      NodeID <- unique(if(i==1){node_list}else{substr(node_list, 1, sep_node-1)})
      ParentID <- if(i==num_lv){rep("Root",length(NodeID))}else{substr(NodeID, 1, sep_parent-1)}
      tr_tmp <- data.frame(NodeID, ParentID, stringsAsFactors=F)
      if(i==1){
        Tree <- tr_tmp
      }else{
        Tree <- rbind(Tree,tr_tmp)}
    }
    Tree <- rbind(Tree,c("Root",""))
    return(list(Tree=Tree, n=n))
  }
  
  # Make a Tree temporal
  tre_pros_temporal <- function(data, AE_code, drug_code, lv_sep){
    n <- xtabs(~get(AE_code)+get(drug_code), data)
    
    node_list <- row.names(n)
    lv_sep_loc <- str_loc(string=node_list, lv_sep=lv_sep)
    
    num_lv <- length(lv_sep_loc[[1]])+1
    
    for(i in 1:num_lv){
      if(i!=1){
        sep_node <- sapply(lv_sep_loc,"[[",num_lv-i+1)
      }
      if(i!=num_lv){
        sep_parent <- sapply(lv_sep_loc,"[[",num_lv-i)
      }
      NodeID <- unique(if(i==1){node_list}else{substr(node_list, 1, sep_node-1)})
      ParentID <- if(i==num_lv){rep("Root",length(NodeID))}else{substr(NodeID, 1, sep_parent-1)}
      tr_tmp <- data.frame(NodeID, ParentID, stringsAsFactors=F)
      if(i==1){
        Tree <- tr_tmp
      }else{
        Tree <- rbind(Tree,tr_tmp)}
    }
    Tree <- rbind(Tree,c("Root",""))
    return(list(Tree=Tree, n=n))
  } 
  # Matching
  # library(Matching)
  Bernoulli.Match <- function(case, control, data, drug_code, match_vars, N){
    
    sub <- data[data[,drug_code] %in% c(case,control),]
    sub$response <- ifelse(sub[,drug_code] == case, 1, 0)
    
    PSModel <- glm(as.formula(paste("response", paste(match_vars, collapse=" + "), sep=" ~ ")), family=binomial(link="logit"), data=sub)
    sub$Probability <- predict(PSModel, type = "response")
    sub$ProbabilityInverse <- 1 - sub$Probability
    
    listMatch <- Match(Tr=sub$response, X=log(sub$Probability/sub$ProbabilityInverse), M=N, caliper=0.25,
                       replace=TRUE, ties=TRUE, version="fast")
    matched_data <- sub[unlist(listMatch[c("index.treated","index.control")]), ]
    matched_data$matched_id <- rep(1:(nrow(matched_data)/2),2)
    rownames(matched_data) <- NULL
    
    return(list(matched_data = matched_data))
  }
  
  pois_cond <- function(n){
    Count <- as.data.frame(cbind(n[,which(colnames(n)%in%case)],apply(n, 1, sum)))
    Count <- Count[!apply(Count, 1, function(x) all(x == 0)), ]
    Count <- as.data.frame(cbind(row.names(Count), Count$V1, Count$V2))
    names(Count) <- c("NodeID","Cases","Population")
    return(Count=Count)
  }
  
  pois_uncond <- function(n, rate){
    Count <- as.data.frame(cbind(n[,which(colnames(n)%in%case)],apply(n, 1, sum)*rate))
    Count <- Count[!apply(Count, 1, function(x) all(x == 0)), ]
    Count <- as.data.frame(cbind(row.names(Count), Count$V1, Count$V2))
    names(Count) <- c("NodeID","Cases","Expectation")
    return(Count=Count)
  }
  
  bern <- function(n){
    Count <- as.data.frame(cbind(n[,which(colnames(n)%in%case)],n[,which(colnames(n)%in%control)]))
    Count <- Count[!apply(Count, 1, function(x) all(x == 0)), ]
    Count <- as.data.frame(cbind(row.names(Count), Count$V1, Count$V2))
    names(Count) <- c("NodeID","Cases","Controls")
    return(Count=Count)
  }
  
  # library(dplyr)
  timetemporal <- function(data, Start, End, drug_code, AE_code, case){
    data$Range <- data[,End] - data[,Start]
    dat <- data[data[drug_code] == case,] %>% add_count(get(AE_code), Range)
    Count <- unique(dat[c(AE_code, "Range", "n")]) %>% select(1,3,2)
    names(Count) <- c("NodeID","Cases","TimeofCases")
    return(Count = Count)
  }
  
  # conditional Poisson
  if(model==0 & is.null(control) & condition==1 ){
    tre<-tre_pros (data=data, AE_code=AE_code, drug_code=drug_code, lv_sep=lv_sep)
    cou<-pois_cond (n=tre$n)
  }
  
  # unconditional Poisson
  if(model==0 & is.null(control) & condition==0 ){
    tre<-tre_pros (data=data, AE_code=AE_code, drug_code=drug_code, lv_sep=lv_sep)
    cou<-pois_uncond (n=tre$n,rate=rate)
  }
  
  # conditional Bernoulli
  if(model==1 & condition==1){
    tre<-tre_pros (data=data[data[,drug_code] %in% c(case,control),], AE_code=AE_code, drug_code=drug_code, lv_sep=lv_sep)
    cou<-bern (n=tre$n)
  }
  
  # unconditional Bernoulli without matching
  if(model==1 & condition==0 & match == 0){
    tre<-tre_pros (data=data[data[,drug_code] %in% c(case,control),], AE_code=AE_code, drug_code=drug_code, lv_sep=lv_sep)
    cou<-bern (n=tre$n)
  }
  
  # unconditional Bernoulli with matching
  if(model==1 & condition==0 & match == 1){
    Match.data <- Bernoulli.Match(case, control, data, drug_code, match_vars, N)$matched_data
    tre<-tre_pros (data=Match.data, AE_code=AE_code, drug_code=drug_code, lv_sep=lv_sep)
    cou<-bern (n=tre$n)
  }
  
  # tree-temporal
  if(model==2 & is.null(control)){
    tre<-tre_pros_temporal(data=data[data[drug_code] == case,], AE_code=AE_code, drug_code=drug_code, lv_sep=lv_sep)
    cou <- timetemporal(data, Start, End, drug_code, AE_code, case)
  }
  
  
  # print(cou)
  row.names(cou) <- 1:nrow(cou)
  
  return(list(Tree=tre$Tree, Count=cou))
}
