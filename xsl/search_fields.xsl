<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <xsl:import href="common.xsl"/> 
    <xsl:import href="generic.xsl"/>
    
    
    <!-- global variable or param -->
    <xsl:variable name="title" select="'Harvard University Course Catalog'"></xsl:variable>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text> 
        <html>
            
        <xsl:variable name="school"><xsl:value-of select="/courses/@school"/></xsl:variable>
       
            <xsl:call-template name="head"/>
            <body>
                <xsl:call-template name="header"/>
                <!-- begin: container -->
                <div class="container theme-showcase">

                    <!-- begin: jumbotron -->
                    <div class="jumbotron">
                        <p class="desc">
                            <xsl:value-of select="$school"/><xsl:text>, Course Catalog</xsl:text>
                        </p>
                        <p class="begin">Begin your course search: </p>
                        <div id="search_field" class="clearfix">
                            <div class="field">
                                <strong>Department: </strong>
                                <xsl:call-template name="department"/> 
                            </div>
                            <div class="field">
                                <strong>Term: </strong>
                                <xsl:call-template name="term"/>
                            </div>
                            <div class="field">
                                <strong>Day: </strong>
                                <xsl:call-template name="days"/>
                            </div>
                            <div class="field">
                                <strong>Time: </strong>
                                <xsl:call-template name="time"/>
                            </div>
                            <div class="field">
                               <strong>Faculty: </strong>
                               <xsl:call-template name="faculty"/>
                            </div>
                            <!-- hidden course group input is just to calculate ajax query string params -->
                            <div class="field course_group">
                               <strong>Course Group: </strong>
                               <xsl:call-template name="course_group"/>
                            </div>
                            <div class="field keyword clearfix">
                               <strong class="float-left">Keyword: </strong>
                               <div class="input-group float-left">
                                  <input id="keyword" type="text" class="param form-control" inputmode="latin" placeholder="Enter keyword"/>
                                </div>
                            </div>  
                        </div>

                        <div class="buttons">
                            <input type="button" id="search" class="btn btn-lg btn-default" value="Find courses" />
                            <input type="button" id="reset" class="btn btn-lg btn-default" value="Start Over"/>
                        </div>  

                    </div>
                    <!-- end: jumbotron-->
                  
                    <div id="results-container" class="row row-offcanvas row-offcanvas-right">
                        <h4>Over 5,000 courses are offered by over 1,900 faculty members within the Faculty of Arts and Sciences. <br />To find a course, please select from the options above.</h4>
                        <ul>
                            <li>
                                <a href="http://www.registrar.fas.harvard.edu/fasro/courses/index.jsp?cat=ugrad&amp;subcat=courses/" target="_blank">Courses of Instruction</a>, <em>Official Register of Harvard University, Faculty of Arts and Sciences</em>
                            </li>
                            <li>
                                <a href="http://q.fas.harvard.edu/" target="_blank">The Q Guide</a>, <em>FAS Office of the Registrar</em>
                                <ul>
                                    <li>Information and student ratings on courses.</li>
                                </ul>
                            </li>
                            <li>
                                <a href="http://www.dce.harvard.edu/" target="_blank">Division of Continuing Education</a>
                            </li>
                        </ul>

                    </div>
                    <xsl:call-template name="footer"/> 
                </div>
                <!-- end: container -->

                <!-- Bootstrap core JavaScript
                ================================================== -->
                <!-- Placed at the end of the document so the pages load faster -->
                <script type="text/javascript" src="js/jquery.js">//</script>
                <script type="text/javascript" src="js/bootstrap.min.js">//</script>
                <script type="text/javascript" src="js/jquery.jqpagination.min.js">//</script>
                <script type="text/javascript" src="js/hash.min.js">//</script>
                <script type="text/javascript" src="js/search.js">//</script>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="department">
        <!-- display unique department name and pass the value by @code -->
        <select class="param" id="dept">
            <option value="all" selected="selected">All</option> 
            <xsl:for-each-group select="/courses/course/department" group-by="dept_short_name">    
                <xsl:sort select="dept_short_name"/>
                <xsl:variable name="dept_code" select="@code"/>
                <option value="{$dept_code}">
                        <xsl:value-of select="current-grouping-key()"/> 
                </option>  
            </xsl:for-each-group>
        </select>
    </xsl:template>
    
    <xsl:template name="term">
        <!-- display unique term and pass the value by @term_pattern_code -->
        <select class="param" id="term">
            <option value="all" selected="selected">All</option>
            <xsl:for-each-group select="/courses/course/term" group-by="@term_pattern_code">    
                <xsl:sort select="@term_pattern_code"/>
                <xsl:variable name="term_code" select="@term_pattern_code"/>
                <option value="{$term_code}">
                    <xsl:value-of select="."/>                     
                </option>  
            </xsl:for-each-group>
        </select>
    </xsl:template>

    <xsl:template name="days">
        <!-- display unique day and pass the value by @day -->
        <select class="param" id="day">
            <option value="all" selected="selected">All</option> 
            <xsl:for-each-group select="/courses/course/schedule/meeting" group-by="@day">    
                <xsl:sort select="@day"/>
                <xsl:variable name="day" select="@day"/>
                <option value="{$day}">
                        <xsl:if test="$day='1'">
                            <xsl:value-of select="'M'"/>
                        </xsl:if>
                        <xsl:if test="$day='2'">
                            <xsl:value-of select="'T'"/>
                        </xsl:if>
                        <xsl:if test="$day='3'">
                            <xsl:value-of select="'W'"/>
                        </xsl:if>
                        <xsl:if test="$day='4'">
                            <xsl:value-of select="'Th'"/>
                        </xsl:if>
                        <xsl:if test="$day='5'">
                            <xsl:value-of select="'F'"/>
                        </xsl:if>
                        <xsl:if test="$day='6'">
                            <xsl:value-of select="'S'"/>
                        </xsl:if>
                </option>  
            </xsl:for-each-group>
        </select>
    </xsl:template>

    <xsl:template name="time">
        <!-- display unique time and pass the value by @begin_time -->
        <select class="param" id="time">
            <option value="all" selected="selected">All</option> 
            <xsl:for-each-group select="/courses/course/schedule/meeting" group-by="@begin_time">    
                <xsl:sort select="number(@begin_time)"/>
                <xsl:variable name="begin_time" select="@begin_time"/>
                <option value="{$begin_time}">  
                    <xsl:choose>
                        <xsl:when test="string-length($begin_time) &gt; 3">
                            <xsl:value-of select="concat(substring($begin_time,1,2),':',substring($begin_time,3,4)) "></xsl:value-of>
                        </xsl:when>
                   <xsl:otherwise>
                       <xsl:value-of select="concat(substring($begin_time,1,1),':',substring($begin_time,2,3)) "/>
                   </xsl:otherwise>
                    </xsl:choose>
                </option>  
            </xsl:for-each-group>
        </select>
    </xsl:template>

    <xsl:template name="faculty">
        <!-- display unique faculty and pass the value by @id -->
        <select class="param" id="faculty">
            <option value="all" selected="selected">All</option> 
            <xsl:for-each-group select="/courses/course/faculty_list/faculty" group-by="@id">    
                <xsl:sort select="name/last"/>
                <xsl:sort select="name/first"/>
                <xsl:sort select="name/middle"/>
                <xsl:variable name="id" select="@id"/>
                <option value="{$id}">  
                    <xsl:value-of select="concat(name/first,' ',name/middle,' ',name/last)"/>
                </option> 
            </xsl:for-each-group>
        </select>
    </xsl:template>

     <xsl:template name="course_group">
        <select class="param" id="course_group">
            <option value="all" selected="selected">All</option>
        </select>
    </xsl:template>
    

</xsl:stylesheet>