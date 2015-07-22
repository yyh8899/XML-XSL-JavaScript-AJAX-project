<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:import href="common.xsl"/> 
  <xsl:import href="generic.xsl"/>
  
  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">>&lt;!DOCTYPE html></xsl:text> 
     <html>
       <xsl:call-template name="head"/>
      <body>
        <xsl:call-template name="header"/>
        
        <!-- begin: container -->
        <div class="container theme-showcase course-detail">  
          <xsl:call-template name="course_details"/>
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
  
  
  
  <xsl:template name="course_details">
        <xsl:apply-templates select="/courses/course[@cat_num eq $cat_num]" />
  </xsl:template>

<!-- Display course detail content -->
  <xsl:template match ="course[@cat_num eq $cat_num]">
    <xsl:variable name="atitle">
      <xsl:value-of select="title"/>
    </xsl:variable>
    <xsl:variable name="acoursegroup">
      <xsl:value-of select="concat(course_group, ' ',course_number/num_int, course_number/num_char)"/>
    </xsl:variable>
    <xsl:variable name="prerequisites">
      <xsl:value-of select="prerequisites"/>
    </xsl:variable>
    <xsl:variable name="notes">
      <xsl:value-of select="notes"/>
    </xsl:variable>

   <!-- begin: breadcrumb -->
   <div class="page-header">
    <ul id="breadcrumbs-one">
      <li><a href="#">Home</a></li>
      <li><a href="#" class="current"><xsl:value-of select="$acoursegroup"/></a></li>
    </ul>
    <p class="return"><a href="javascript:history.back()">Return to search results</a></p>
   </div>
   <!-- end: breadcrumb -->

   <!-- course details-->
    <div class="jumbotron">
      <h2><xsl:value-of select="$atitle"/></h2>
      <h4><xsl:value-of select="$acoursegroup"/><xsl:text>. </xsl:text><xsl:value-of select="$atitle"/></h4>
    
      <h4>Catalog Number: <xsl:value-of select="$cat_num"/></h4>
      <h4>Instructor: <i><xsl:value-of select="faculty_text"/></i></h4>
      <h4><xsl:value-of select="credit"/><xsl:text> (</xsl:text><xsl:value-of select="term"/><xsl:text>). </xsl:text><xsl:value-of select="replace(meeting_text,'&amp;#8211;',' – ')" disable-output-escaping="yes"/>
     </h4>
      <h4>Level: <xsl:value-of select="concat(course_level,' / ', course_type)"/></h4>
      <hr/>
      <p><strong>Description: </strong> <xsl:value-of select="replace(replace(replace(replace(replace(description, '&amp;#346','Ś'), '&amp;#257', 'ā'), '&amp;#7749','ṅ' ), '&amp;#347','ś'),'&amp;#151','—')" disable-output-escaping="yes"/></p>
      <xsl:if test="$prerequisites !=''">
        <p><strong>Prerequisites: </strong><xsl:value-of select="$prerequisites"/></p>
        </xsl:if>
      <xsl:if test="$notes !=''">
        <p><i><strong>Notes: </strong></i> <xsl:value-of select="$notes"/></p>
      </xsl:if>
    </div>

  </xsl:template>

</xsl:stylesheet>
