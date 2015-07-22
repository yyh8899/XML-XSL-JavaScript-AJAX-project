<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/> 
    
    <!-- global variable or param -->
    
    <xsl:template name="head">
        <head>
            <title>
                <xsl:value-of select="$title"/>
            </title>

            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            
            <!-- Bootstrap core CSS -->
            <link rel="stylesheet" type="text/css" href="{$baselink}css/bootstrap.min.css" />
            <link rel="stylesheet" type="text/css" href="{$baselink}css/bootstrap-theme.min.css" />
            
            <!-- Custom CSS -->
            <link rel="stylesheet" type="text/css" href="{$baselink}css/site.css" />
            
            <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
            <!--[if lt IE 9]>
                  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
                  <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
                <![endif]-->
        </head>
    </xsl:template>

    <xsl:template name="header">
        <div class="navbar navbar-fixed-top" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="{$baselink}/cocoon/final_project/index.html">
                        <img src="{$baselink}images/harvard_shield.png" alt="Havard Logo"/>
                        Harvard University
                    </a>
                </div>
                <div class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="{$baselink}/cocoon/final_project/index.html">Home</a></li>
                        <li><a href="http://www.fas.harvard.edu/pages/departments-and-areas" target="_blank">Departments</a></li>
                        <li><a href="http://www.fas.harvard.edu/pages/degree-programs-courses" target="_blank">Degree Programs</a></li>
                    </ul>
                </div><!--/.nav-collapse -->
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="footer">
        <xsl:variable name="school"><xsl:value-of select="/courses/@school"/></xsl:variable>
        <!-- begin: footer -->
        <div id="footer">
            <hr/>
            <p>
                <a href="http://www.harvard.edu/"><xsl:value-of select="$school"/></a> | 
                <a href="https://coursecatalog.harvard.edu/icb/icb.do"><xsl:value-of select="$title"/></a> |
                <a href="http://www.college.harvard.edu/icb/icb.do">Harvard College</a> |
                <a href="http://www.gsas.harvard.edu/">Graduate school Arts &amp; Sciences</a>
            </p>
        </div>
        <!-- end: footer -->
    </xsl:template>

    
</xsl:stylesheet>