# 安装并加载必要的包

library(ggplot2)
library(readxl)

# 读取Excel数据
df <- read_excel("C:\\Users\\JiangXR\\Desktop\\hong_analysis\\ABEV-ana\\new-final-ABVE.xlsx", sheet = 1)

# 将百分比转换为小数（除以100）
df$Archaea <- df$Archaea / 100
df$Bacteria <- df$Bacteria / 100
df$Eukaryota <- df$Eukaryota / 100
df$Viruses <- df$Viruses / 100

# 将数据转换为长格式（ggplot2需要）
library(tidyr)
df_long <- df %>%
              pivot_longer(cols = c(Archaea, Viruses, Bacteria, Eukaryota),
                           names_to = "Domain", values_to = "Abundance")
library(dplyr)   # 如果还没加载就加一行

df_long <- df %>% 
              pivot_longer(cols = c(Archaea, Viruses, Bacteria, Eukaryota),
                           names_to = "Domain",
                           values_to = "Abundance") %>% 
              mutate(Abundance = if_else(Domain %in% c("Archaea","Viruses"),
                                         Abundance * 100,      # 扩大 10 倍
                                         Abundance))          # Bacteria 不变
# 绘图
ggplot(df_long, aes(x = domain, y = Abundance, fill = Domain)) +
              geom_col(position = "dodge") +
              theme_bw()+
              # 左侧Y轴：细菌
              scale_y_continuous(
                            name = "Bacteria/Eukaryota Relative Abundance",
                            labels = scales::percent,
                            sec.axis = sec_axis(~ . /100, name = "Archaea / Viruses Relative Abundance",
                                                labels = scales::percent)
              ) +
              
              # 颜色映射
              scale_fill_manual(values = c("Archaea" = "pink", "Viruses" = "thistle",
                                           "Bacteria" = "turquoise4", 
                                           "Eukaryota" = "palegreen", 
                                           )) +
              
              labs(x = "Sample", title = "Relative Abundance of Microbial Domains") +
              theme_bw()
library(ggplot2)
