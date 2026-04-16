library(hexSticker)
library(ggplot2)
library(showtext)
library(sysfonts)

font_add_google("Rajdhani", "rajdhani")
font_add_google("Orbitron", "orbitron")
showtext_auto()

out_dir <- "inst/images"

blank <- function() {
  ggplot() +
    theme_void() +
    theme(
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background  = element_rect(fill = "transparent", colour = NA)
    )
}

# ── OPTION 1 ─ Isometric cube (navy + cyan) ──────────────────────────────────
# Hardcode 7 vertices of an isometric cube viewed from top-right-front.
# The cube projects as a hexagon split into 3 rhombus faces.

make_cube <- function() {
  s <- 0.80  # scale

  # 7 named points of the visible isometric cube
  cx  <- 0;        cy  <- 0              # centre
  top_x  <- 0;     top_y  <- s          # top apex
  tr_x   <-  s * cos(pi/6); tr_y <- s * 0.5   # top-right
  br_x   <-  s * cos(pi/6); br_y <- -s * 0.5  # bottom-right
  bot_x  <- 0;     bot_y  <- -s         # bottom apex
  bl_x   <- -s * cos(pi/6); bl_y <- -s * 0.5  # bottom-left
  tl_x   <- -s * cos(pi/6); tl_y <-  s * 0.5  # top-left

  top_face  <- data.frame(x = c(top_x, tr_x, cx, tl_x), y = c(top_y, tr_y, cy, tl_y))
  right_face <- data.frame(x = c(tr_x, br_x, bot_x, cx), y = c(tr_y, br_y, bot_y, cy))
  left_face  <- data.frame(x = c(tl_x, cx, bot_x, bl_x), y = c(tl_y, cy, bot_y, bl_y))

  # All 6 outer edges + 3 inner spokes from centre
  segs <- data.frame(
    x    = c(top_x, tr_x, br_x, bot_x, bl_x, tl_x,  cx,  cx,  cx),
    y    = c(top_y, tr_y, br_y, bot_y, bl_y, tl_y,  cy,  cy,  cy),
    xend = c(tr_x, br_x, bot_x, bl_x, tl_x, top_x, top_x, br_x, bl_x),
    yend = c(tr_y, br_y, bot_y, bl_y, tl_y, top_y, top_y, br_y, bl_y)
  )

  blank() +
    geom_polygon(data = top_face,   aes(x, y), fill = "#1E7FBF", colour = NA) +
    geom_polygon(data = right_face, aes(x, y), fill = "#0D5080", colour = NA) +
    geom_polygon(data = left_face,  aes(x, y), fill = "#0A3A5C", colour = NA) +
    geom_segment(data = segs,
                 aes(x=x, y=y, xend=xend, yend=yend),
                 colour = "#00D4FF", linewidth = 0.7, lineend = "round") +
    coord_fixed() +
    xlim(-1.1, 1.1) + ylim(-1.0, 1.0)
}

sticker(
  subplot    = make_cube(),
  package    = "AutoDeskR",
  p_size     = 16,
  p_color    = "#00D4FF",
  p_family   = "rajdhani",
  p_y        = 0.38,
  s_x        = 1.0,
  s_y        = 1.05,
  s_width    = 1.0,
  s_height   = 0.95,
  h_fill     = "#0B1F33",
  h_color    = "#00D4FF",
  h_size     = 1.5,
  filename   = file.path(out_dir, "sticker1_cube.png"),
  dpi        = 300
)
cat("Option 1 saved\n")


# ── OPTION 2 ─ City skyline (teal + white) ────────────────────────────────────

make_building <- function() {
  bldgs <- data.frame(
    xmin = c(-1.0, -0.65, -0.18,  0.18,  0.50,  0.72),
    xmax = c(-0.72, -0.25,  0.12,  0.47,  0.70,  1.00),
    ymin = rep(-0.85, 6),
    ymax = c( 0.20,   0.60,  0.85,  0.45,  0.95,  0.35)
  )

  # Small square windows punched out in darker teal
  win_cols <- c(-0.87, -0.87, -0.46, -0.46, -0.05, -0.05,
                 0.30,  0.30,  0.59,  0.59)
  win_rows <- c(-0.05,  0.18,  0.06,  0.30,  0.22,  0.48,
                 0.04,  0.24,  0.35,  0.60)
  wins <- data.frame(
    xmin = win_cols - 0.05, xmax = win_cols + 0.05,
    ymin = win_rows - 0.04, ymax = win_rows + 0.04
  )
  # Keep only windows that actually fall inside a building
  wins <- wins[wins$xmin > -1.02 & wins$xmax < 1.02, ]

  blank() +
    geom_rect(data = bldgs, aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill = "#FFFFFF", colour = NA) +
    geom_rect(data = wins,  aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill = "#0D6E6E", colour = NA) +
    coord_fixed() +
    xlim(-1.2, 1.2) + ylim(-1.0, 1.1)
}

sticker(
  subplot    = make_building(),
  package    = "AutoDeskR",
  p_size     = 18,
  p_color    = "#FFFFFF",
  p_family   = "rajdhani",
  p_y        = 1.55,
  s_x        = 1.0,
  s_y        = 0.82,
  s_width    = 1.15,
  s_height   = 1.05,
  h_fill     = "#0D6E6E",
  h_color    = "#04C5B8",
  h_size     = 1.5,
  filename   = file.path(out_dir, "sticker2_building.png"),
  dpi        = 300
)
cat("Option 2 saved\n")


# ── OPTION 3 ─ API node graph (graphite + orange) ────────────────────────────

make_network <- function() {
  nodes <- data.frame(
    x  = c( 0.00,  -0.55,  0.55,  -0.28,  0.28, -0.75,  0.75, -0.40,  0.40,  0.00),
    y  = c( 0.80,   0.30,  0.30,  -0.10, -0.10, -0.55, -0.55, -0.85, -0.85, -0.22),
    id = 1:10
  )
  el <- rbind(c(1,2),c(1,3),c(2,4),c(3,5),c(4,5),c(4,8),c(5,9),
              c(2,6),c(3,7),c(6,8),c(7,9),c(8,9),c(4,10),c(5,10))
  edges <- data.frame(
    x=nodes$x[el[,1]], y=nodes$y[el[,1]],
    xend=nodes$x[el[,2]], yend=nodes$y[el[,2]]
  )

  blank() +
    geom_segment(data=edges, aes(x=x,y=y,xend=xend,yend=yend),
                 colour="#FF8C00", linewidth=0.55, alpha=0.8) +
    geom_point(data=nodes, aes(x,y),
               colour="#FFFFFF", fill="#FF8C00",
               shape=21, size=2.6, stroke=0.9) +
    coord_fixed() +
    xlim(-1.1, 1.1) + ylim(-1.05, 1.05)
}

sticker(
  subplot    = make_network(),
  package    = "AutoDeskR",
  p_size     = 16,
  p_color    = "#FF8C00",
  p_family   = "rajdhani",
  p_y        = 0.38,
  s_x        = 1.0,
  s_y        = 1.05,
  s_width    = 1.0,
  s_height   = 0.95,
  h_fill     = "#1C1C2E",
  h_color    = "#FF8C00",
  h_size     = 1.5,
  filename   = file.path(out_dir, "sticker3_network.png"),
  dpi        = 300
)
cat("Option 3 saved\n")
