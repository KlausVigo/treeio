
##' @importFrom ape which.edge
gfocus <- function(phy, focus, group_name, focus_label=NULL,
                   overlap="overwrite", connect = FALSE) {

    ## see https://groups.google.com/forum/#!msg/bioc-ggtree/Q4LnwoTf1DM/yEe95OFfCwAJ
    ## for connect parameter

    overlap <- match.arg(overlap, c("origin", "overwrite", "abandon"))

    if (is.character(focus)) {
        focus <- which(phy$tip.label %in% focus)
    }

    n <- getNodeNum(phy)
    if (is.null(attr(phy, group_name))) {
        foc <- rep(0, n)
    } else {
        foc <- attr(phy, group_name)
    }
    i <- max(suppressWarnings(as.numeric(foc)), na.rm=TRUE) + 1
    if (is.null(focus_label)) {
        focus_label <- i
    }

    induced_edge <- phy$edge[which.edge(phy, focus),]

    hit <- unique(as.vector(induced_edge))
    if (overlap == "origin") {
        sn <- hit[is.na(foc[hit]) | foc[hit] == 0]
    } else if (overlap == "abandon") {
        idx <- !is.na(foc[hit]) & foc[hit] != 0
        foc[hit[idx]] <- NA
        sn <- hit[!idx]
    } else {
        sn <- hit
    }

    if (length(sn) > 0 && connect) {
        if (sum(table(induced_edge[,1]) > 1) == 1) {
            sn <- focus
        }
    }

    if (length(sn) > 0) {
        foc[sn] <- focus_label
    }

    attr(phy, group_name) <- foc
    phy
}


##' @method groupOTU phylo
##' @export
groupOTU.phylo <- function(.data, .node, group_name="group", ...) {
    phy <- .data
    focus <- .node
    attr(phy, group_name) <- NULL
    if ( is(focus, "list") ) {
        for (i in 1:length(focus)) {
            phy <- gfocus(phy, focus[[i]], group_name, names(focus)[i], ...)
        }
    } else {
        phy <- gfocus(phy, focus, group_name, ...)
    }
    res <- attr(phy, group_name)
    res[is.na(res)] <- 0
    attr(phy, group_name) <- factor(res)
    return(phy)
}

##' @method groupOTU treedata
##' @export
groupOTU.treedata <- function(.data, .node, group_name = "group", ...) {
    .data@phylo <- groupOTU(as.phylo(.data), .node, group_name, ...)
}
