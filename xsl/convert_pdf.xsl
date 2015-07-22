<?xml version="1.0" encoding="utf-8" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
   <xsl:import href="common.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- fo style -->
        <xsl:attribute-set name="normal">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">12pt</xsl:attribute> 
        </xsl:attribute-set>
        <xsl:attribute-set name="italic">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">12pt</xsl:attribute>
            <xsl:attribute name="font-style">italic</xsl:attribute> 
        </xsl:attribute-set>
        <xsl:attribute-set name="toc">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">10pt</xsl:attribute> 
            <xsl:attribute name="space-after.optimum">3pt</xsl:attribute> 
        </xsl:attribute-set>
        <xsl:attribute-set name="des">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">10pt</xsl:attribute>
            <xsl:attribute name="margin-left">1em</xsl:attribute>
            <xsl:attribute name="padding-top">0.5em</xsl:attribute>
        </xsl:attribute-set>
         <xsl:attribute-set name="title1">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">18pt</xsl:attribute> 
            <xsl:attribute name="font-weight">bold</xsl:attribute> 
             <xsl:attribute name="line-height">24pt</xsl:attribute> 
             <xsl:attribute name="space-after.optimum">15pt</xsl:attribute> 
            <xsl:attribute name="text-align">center</xsl:attribute> 
            <xsl:attribute name="padding">1em</xsl:attribute> 
        </xsl:attribute-set>
         <xsl:attribute-set name="title2">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">14pt</xsl:attribute> 
            <xsl:attribute name="font-weight">bold</xsl:attribute> 
            <xsl:attribute name="text-align">center</xsl:attribute> 
            <xsl:attribute name="padding">0.5em</xsl:attribute> 
        </xsl:attribute-set>
        <xsl:attribute-set name="title3">
            <xsl:attribute name="font-family">Arial,sans-serif</xsl:attribute> 
            <xsl:attribute name="font-size">12pt</xsl:attribute> 
            <xsl:attribute name="font-weight">bold</xsl:attribute> 
            <xsl:attribute name="padding">0.5em</xsl:attribute> 
        </xsl:attribute-set>
    <!-- end fo style -->
   
  <!-- main template -->
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="simple" page-height="11in" page-width="8.5in" 
                    margin-top="1.0in" margin-bottom="1.0in" margin-left="1.0in" margin-right="1.0in">
                    <fo:region-body margin-top="0.7in" margin-bottom="0.7in" /> 
                    <fo:region-before extent="0.5in" /> 
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="simple">
                <!-- static content, page header -->
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block font-size="8pt" text-align="end">
                        Harvard University,  <xsl:value-of select="/courses/@school"/>, Course Catalog, Page 
                        <fo:page-number/>
                        <xsl:text> of </xsl:text>     
                        <fo:page-number-citation ref-id="theEnd"/> 
                    </fo:block>
                </fo:static-content>
                <!-- flow, body content -->
                <fo:flow flow-name="xsl-region-body"> 
                   
                        <xsl:if test="$dept !='all'">
                            <!-- heading -->
                            <fo:block  xsl:use-attribute-sets="title1">
                                Department of <xsl:value-of select="distinct-values(/courses/course/department[@code=$dept]/dept_short_name)"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="$dept ='all'">
                            <!-- heading -->
                            <fo:block  xsl:use-attribute-sets="title1">
                                Department of <xsl:value-of select="distinct-values(/courses/course/department/dept_short_name)"/>
                            </fo:block>
                        </xsl:if>

                        <!-- course index, table of content -->
                        <fo:block>
                            <xsl:apply-templates select="/courses" mode="toc"/> 
                        </fo:block>
                        <!-- course details -->
                        <fo:block break-before="page">
                            <xsl:apply-templates select="/courses" mode="main"/> 
                        </fo:block>
                       
                   
               
                       <!--  last block for "theEnd" id  --> 
                        <fo:block id="theEnd" /> 
                   
                </fo:flow>
                <!--  closes the flow element--> 
            </fo:page-sequence>            
        </fo:root>      
    </xsl:template>
   <!-- end main template -->
    
    <!-- Table of content template -->
    <xsl:template match="courses" mode="toc" >
        <!-- display course lists group by course group -->
       <xsl:variable name="displaygroup">
           <xsl:for-each select="distinct-values(course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
               and ($dept = 'all' or department/@code=$dept)
               and ($course_group = 'all' or course_group/@code=$course_group)
               and($term = 'all' or term/@term_pattern_code=$term)
               and($day = 'all' or schedule/meeting/@day=$day)
               and($time = 'all' or schedule/meeting/@begin_time=$time)
               and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]/course_group)">
            <xsl:sort select="."/>
            <xsl:variable name="count" select="position()"/>
             <xsl:if test="position()=last()">
                    <xsl:if test="$count>1">
                        <xsl:value-of>yes</xsl:value-of>
                    </xsl:if>
             </xsl:if>
        </xsl:for-each>   
       </xsl:variable>
 
        <xsl:for-each-group select="course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
            and ($dept = 'all' or department/@code=$dept)
            and ($course_group = 'all' or course_group/@code=$course_group)
            and($term = 'all' or term/@term_pattern_code=$term)
            and($day = 'all' or schedule/meeting/@day=$day)
            and($time = 'all' or schedule/meeting/@begin_time=$time)
            and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]" group-by="course_group">     
            <xsl:sort select="course_group"/> 
            <!-- display indexed course group if course group is more than 1 -->  
                <xsl:if test="$displaygroup ='yes'">
                    <fo:block xsl:use-attribute-sets="title3" text-align-last="justify" >
                            <xsl:value-of select="current-grouping-key()"/>
                        <fo:leader leader-pattern="dots" /> 
                        <fo:page-number-citation>
                            <xsl:attribute name="ref-id">
                                <xsl:value-of select="generate-id()" /> 
                            </xsl:attribute>
                        </fo:page-number-citation>
                     </fo:block>
                </xsl:if>
            <!-- display indexed course title -->    
                <xsl:for-each select="current-group()">
                    <xsl:sort select="course_number/num_int" data-type="number"/> 
                    <xsl:sort select="course_number/num_char" /> 
                    <xsl:sort select="title" /> 
                    
                    <fo:block xsl:use-attribute-sets="toc" text-align-last="justify">
                        <fo:basic-link internal-destination="{generate-id()}"> 
                            <xsl:variable name="course">
                                <xsl:value-of select="concat(course_group,' ',course_number/num_int,course_number/num_char)"/><xsl:text>. </xsl:text><xsl:value-of select="title"/>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="instructor_approval_required eq 'Y'">
                                    <xsl:text>*</xsl:text><xsl:value-of select="$course"/>
                                </xsl:when>
                                <xsl:when test="./@offered eq 'N'">
                                    <xsl:text>[</xsl:text><xsl:value-of select="$course"/><xsl:text>]</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$course"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:basic-link>
                        <fo:leader leader-pattern="dots" /> 
                        <fo:page-number-citation>
                            <xsl:attribute name="ref-id">
                                <xsl:value-of select="generate-id()" /> 
                            </xsl:attribute>
                        </fo:page-number-citation>
                    </fo:block>
                </xsl:for-each>
            
        </xsl:for-each-group> 
    </xsl:template>
    <!-- end table of content template -->
    
    <!-- course content template -->
    <xsl:template match ="courses" mode="main">
        <xsl:for-each-group select="course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
            and ($dept = 'all' or department/@code=$dept)
            and ($course_group = 'all' or course_group/@code=$course_group)
            and($term = 'all' or term/@term_pattern_code=$term)
            and($day = 'all' or schedule/meeting/@day=$day)
            and($time = 'all' or schedule/meeting/@begin_time=$time)
            and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]" group-by="course_group">     
            <xsl:sort select="course_group"/> 
            <fo:block xsl:use-attribute-sets="title3">
                    <xsl:value-of select="current-grouping-key()"/>
                </fo:block>
            <xsl:for-each select="current-group()">
                <xsl:sort select="course_number/num_int" data-type="number"/> 
                <xsl:sort select="course_number/num_char" /> 
                <xsl:sort select="title" /> 
                <!-- declare variables -->
                    <xsl:variable name="course">
                        <xsl:value-of select="concat(course_group,' ',course_number/num_int,course_number/num_char)"/><xsl:text>. </xsl:text><xsl:value-of select="title"/>
                    </xsl:variable>
                    <xsl:variable name="prerequisites">
                        <xsl:value-of select="prerequisites"/>
                    </xsl:variable>
                    <xsl:variable name="notes">
                        <xsl:value-of select="notes"/>
                    </xsl:variable>
                <!-- end declare variable -->
                <!-- display course details -->
              
                <fo:block id="{generate-id()}"  xsl:use-attribute-sets="title3">
                    <xsl:choose>
                        <xsl:when test="instructor_approval_required eq 'Y'">
                            <xsl:text>*</xsl:text><xsl:value-of select="$course"/>
                        </xsl:when>
                        <xsl:when test="./@offered eq 'N'">
                            <xsl:text>[</xsl:text><xsl:value-of select="$course"/><xsl:text>]</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$course"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
                <fo:block xsl:use-attribute-sets="normal">
                     Catalog Number: <xsl:value-of select="@cat_num"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="italic">
                     <xsl:value-of select="faculty_text"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="italic">
                     <xsl:value-of select="credit"/><xsl:text> (</xsl:text><xsl:value-of select="term"/><xsl:text>). </xsl:text><xsl:value-of select="replace(meeting_text,'&amp;#8211;',' – ')" disable-output-escaping="yes"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="normal">
                    <xsl:value-of select="concat(course_level,' / ', course_type)"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="des">
                    <xsl:value-of select="replace(replace(replace(replace(replace(description, '&amp;#346','Ś'), '&amp;#257', 'ā'), '&amp;#7749','ṅ' ), '&amp;#347','ś'),'&amp;#151','—')" disable-output-escaping="yes"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="des">
                    <xsl:if test="$notes !=''">
                        <fo:inline font-style="italic">Notes: </fo:inline> <xsl:value-of select="$notes"/>
                    </xsl:if>
                </fo:block>
                <fo:block xsl:use-attribute-sets="des">
                    <xsl:if test="$prerequisites !=''">
                        Prerequisites: <xsl:value-of select="$prerequisites"/>
                    </xsl:if>
                </fo:block>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>
    <!-- end of course content template -->
    
</xsl:stylesheet>