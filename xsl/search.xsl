<?xml version="1.0" encoding="utf-8" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" >
  <xsl:import href="common.xsl"/>
  
  <!-- total records -->
  <xsl:variable name="totnum">
    <xsl:value-of select="count(/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
      and ($dept = 'all' or department/@code=$dept)
      and ($course_group = 'all' or course_group/@code=$course_group)
      and($term = 'all' or term/@term_pattern_code=$term)
      and($day = 'all' or schedule/meeting/@day=$day)
      and($time = 'all' or schedule/meeting/@begin_time=$time)
      and($faculty = 'all' or faculty_list/faculty/@id=$faculty)])"/> 
  </xsl:variable>
  
  <!-- Calculate how many pages will be needed in total -->
  <xsl:variable name="pagetotal" select="ceiling($totnum div 40)"/>
  
  <xsl:template match="/">
   
    <xsl:variable name="current_page">   
      <xsl:choose>  
        <xsl:when test="string($page) = ''"> 
          <xsl:value-of select="0"/>      
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($page) - 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- begin: left column -->
    <div class="col-xs-12 col-sm-9">

      <div class="results">
        <!-- begin: narrow results row -->
        <div class="row refine-results">
          <div class="col-md-4 courses-found">
              <span class="label">Courses found: </span>
              <div id="total-pages" style="display:none"><xsl:value-of select="$pagetotal"/></div>
              <xsl:value-of select="$totnum"/>
          </div>
         
           <!-- if the department, term and time are not selected, a sort options provided-->
          <xsl:if test="($dept ='all')or($term ='all')or($day ='all')or($time ='all')">
            <div class="col-md-4 sort-by">
              <span class="label">Sort by: </span>
              <div class="btn-group">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                  Select option<span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu">
                      <xsl:if test="$dept ='all'">
                        <li><a href="#" class="sort-results" id="department">Department</a></li>
                      </xsl:if>
                      <xsl:if test="$term ='all'">
                        <li><a href="#" class="sort-results" id="term">Term</a></li>
                     </xsl:if>
                     <xsl:if test="$day ='all'">
                      <li><a href="#" class="sort-results" id="day">Day</a></li>
                    </xsl:if>
                    <xsl:if test="$time ='all'">
                      <li><a href="#" class="sort-results" id="time">Time</a></li>
                  </xsl:if>
                </ul>
              </div>
            </div>
          </xsl:if>

          <div class="col-md-4 view-by">
            <span class="label">Download: </span>
            <a href="ajax/search.pdf" class="btn btn-default" id="pdf_link">PDF</a>
          </div>
        </div>
        <!-- end: narrow results row -->
       
        <!-- begin: course search results condition by sort -->
        <xsl:choose>
       <xsl:when test="$sort='department'">
          <xsl:apply-templates select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
            and ($dept = 'all' or department/@code=$dept)
            and ($course_group = 'all' or course_group/@code=$course_group)
            and($term = 'all' or term/@term_pattern_code=$term)
            and($day = 'all' or schedule/meeting/@day=$day)
            and($time = 'all' or schedule/meeting/@begin_time=$time)
            and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]">
            <xsl:sort select="department/dept_short_name"/>
            <xsl:with-param name="start_no" select="($current_page * 40 ) + 1" />
            <xsl:with-param name="end_no" select="($current_page * 40 ) + 40" />
          </xsl:apply-templates>
       </xsl:when>  
        <xsl:when test="$sort='term'">
          <xsl:apply-templates select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
            and ($dept = 'all' or department/@code=$dept)
            and ($course_group = 'all' or course_group/@code=$course_group)
            and($term = 'all' or term/@term_pattern_code=$term)
            and($day = 'all' or schedule/meeting/@day=$day)
            and($time = 'all' or schedule/meeting/@begin_time=$time)
            and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]">
            <xsl:sort select="term/@term_pattern_code"/>
            <xsl:with-param name="start_no" select="($current_page * 40 ) + 1" />
            <xsl:with-param name="end_no" select="($current_page * 40 ) + 40" />
          </xsl:apply-templates>
        </xsl:when> 
          <xsl:when test="$sort='day'">
            <xsl:apply-templates select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]">
              <xsl:sort select="schedule/meeting[1]/@day"/>
              <xsl:with-param name="start_no" select="($current_page * 40 ) + 1" />
              <xsl:with-param name="end_no" select="($current_page * 40 ) + 40" />
            </xsl:apply-templates>
          </xsl:when> 
          <xsl:when test="$sort='time'">
            <xsl:apply-templates select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]">
              <xsl:sort select="schedule/meeting[1]/@begin_time"/>
              <xsl:with-param name="start_no" select="($current_page * 40 ) + 1" />
              <xsl:with-param name="end_no" select="($current_page * 40 ) + 40" />
            </xsl:apply-templates>
          </xsl:when> 
        <xsl:otherwise>
          <xsl:apply-templates select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
            and ($dept = 'all' or department/@code=$dept)
            and ($course_group = 'all' or course_group/@code=$course_group)
            and($term = 'all' or term/@term_pattern_code=$term)
            and($day = 'all' or schedule/meeting/@day=$day)
            and($time = 'all' or schedule/meeting/@begin_time=$time)
            and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]">
            <xsl:with-param name="start_no" select="($current_page * 40 ) + 1" />
            <xsl:with-param name="end_no" select="($current_page * 40 ) + 40" />
          </xsl:apply-templates>
          
        </xsl:otherwise>
        </xsl:choose>
        
        <!-- end: course search results -->
      
        
       <xsl:if test="$totnum &gt; 40">
        <!-- begin: pagination -->
        <div class="pagination">
          <a href="#" class="first" data-action="first"><xsl:text disable-output-escaping="yes">&#171;</xsl:text></a>
          <a href="#" class="previous" data-action="previous"><xsl:text disable-output-escaping="yes">&#8249;</xsl:text></a>
          <input type="text" readonly="readonly" data-max-page="40" />
          <a href="#" class="next" data-action="next"><xsl:text disable-output-escaping="yes">&#8250;</xsl:text></a>
          <a href="#" class="last" data-action="last"><xsl:text disable-output-escaping="yes">&#187;</xsl:text></a>
        </div>
        <!-- end: pagination -->
        </xsl:if>
      </div>
    </div>
    <!-- end: left column -->

    <!-- begin: right column-->
    <div class="col-xs-6 col-sm-3 sidebar-offcanvas">
      <h3>NARROW RESULTS:</h3>
      <xsl:call-template name="search_term"/>
      <!--if result is 0, no need to further narrow results; if result is >0, display navigation to further narrow results-->
        <xsl:if test="$totnum != 0">
          <xsl:call-template name="sidebar"/>
        </xsl:if>
    </div>  
    <!-- end: right column -->

  </xsl:template>
  
  <xsl:template match ="course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
      and ($dept = 'all' or department/@code=$dept)
      and ($course_group = 'all' or course_group/@code=$course_group)
      and($term = 'all' or term/@term_pattern_code=$term)
      and($day = 'all' or schedule/meeting/@day=$day)
      and($time = 'all' or schedule/meeting/@begin_time=$time)
      and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]">
       
      <!-- paging start and end -->
      <xsl:param name="start_no" />
      <xsl:param name="end_no" />
      <xsl:variable name="catalog_num" select="./@cat_num"></xsl:variable>
      
      <xsl:if test="position() &gt;= ($start_no) and position() &lt;= ($end_no)"> 
        <a href="courses/{$catalog_num}.html">
          <div class="course">
            <div class="heading">
              <span class="code">
                <xsl:value-of select="$catalog_num"/>
                <xsl:text>:</xsl:text>
              </span>
              <span class="title"><xsl:value-of select="title"/></span>
            </div>
            <!--<div class="description"><xsl:value-of select="description"/></div>-->
            <div class="description"> <xsl:value-of select="concat(course_group,' ',course_number/num_int,course_number/num_char)"/></div>
            <div class="footer">
              <div class="term"><span class="label">Term: </span><xsl:value-of select="term"/></div>
              <div class="schedule"><span class="label">Schedule: </span><xsl:value-of select="replace(meeting_text,'&amp;#8211;',' – ')"/></div>
              <div class="faculty"><span class="label">Instructor: </span><xsl:value-of select="faculty_text"/></div>
            </div>
          </div>
        </a>
      </xsl:if>

  </xsl:template>
  
  <xsl:template name="search_term">
    <div id="search_term">
      <xsl:if test="($dept !='all') or ($term !='all') or ($day != 'all') or($time != 'all') or ($faculty !='all')">
        <h4>Currently narrowed by:</h4>
        <p>
          <xsl:if test="$dept !='all'">
            <a style="display:block;" class="remove-result" id="delete-dept"><img src="images/icon_delete.gif" alt="delete"/><span>Dept: </span><xsl:text> </xsl:text><xsl:value-of select="distinct-values(/courses/course/department[@code=$dept]/dept_short_name)"/></a>
          </xsl:if>
          <xsl:if test="$course_group !='all'">
            <a style="display:block;" class="remove-result" id="delete-dept"><img src="images/icon_delete.gif" alt="delete"/><span>Course group: </span><xsl:text> </xsl:text><xsl:value-of select="distinct-values(/courses/course/course_group[@code=$course_group]/@code)"/></a>
          </xsl:if>
          <xsl:if test="$term !='all'">
            <a style="display:block;" class="remove-result" id="delete-term"><img src="images/icon_delete.gif" alt="delete"/><span>Term: </span><xsl:text> </xsl:text><xsl:value-of select="distinct-values(/courses/course/term[@term_pattern_code=$term])"/></a>
          </xsl:if>
          <xsl:if test="$day !='all'">
            <a style="display:block;" class="remove-result" id="delete-day">
              <img src="images/icon_delete.gif" alt="delete"/><span>Day: </span><xsl:text> </xsl:text>
              <xsl:if test="$day='1'">
                <xsl:text>M</xsl:text>
              </xsl:if>
              <xsl:if test="$day='2'">
                <xsl:text>T</xsl:text>
              </xsl:if>
              <xsl:if test="$day='3'">
                <xsl:text>W</xsl:text>
              </xsl:if>
              <xsl:if test="$day='4'">
                <xsl:text>Th</xsl:text>
              </xsl:if>
              <xsl:if test="$day='5'">
                <xsl:text>F</xsl:text>
              </xsl:if>
                <xsl:if test="$day='6'">
                  <xsl:text>S</xsl:text>
                </xsl:if>
            </a>
          </xsl:if>
          <xsl:if test="$time !='all'">
            <a style="display:block;" class="remove-result" id="delete-time">
              <img src="images/icon_delete.gif" alt="delete"/><span>Time: </span><xsl:text> </xsl:text>
              <xsl:choose>
              <xsl:when test="string-length($time) &gt; 3">
                <xsl:value-of select="concat(substring($time,1,2),':',substring($time,3,4)) "></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(substring($time,1,1),':',substring($time,2,3)) "/>
              </xsl:otherwise>
            </xsl:choose></a>
          </xsl:if>
          <xsl:if test="$faculty !='all'">
            <a style="display:block;" class="remove-result" id="delete-faculty">
              <img src="images/icon_delete.gif" alt="delete"/><span>Faculty: </span><xsl:text> </xsl:text><xsl:value-of select="concat(distinct-values(/courses/course/faculty_list/faculty[@id=$faculty]/name/first),
              ' ',distinct-values(/courses/course/faculty_list/faculty[@id=$faculty]/name/last))"/></a>
          </xsl:if>
        </p>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- when the result is > 0, the navigation appear for user to narrow down the results -->
  <xsl:template name="sidebar">
    <h4>Further narrow by:</h4>
   <xsl:if test="$dept ='all'">
    <!-- narrow by: department & course group -->
    <div>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title">
            <xsl:text>By Department and course group</xsl:text>
          </h3>
        </div>
        <div class="panel-body">
          <ul id="narrow-dept">
            <xsl:for-each-group select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]/department" group-by="dept_short_name">    
              <xsl:sort select="dept_short_name"/>
              <xsl:variable name="thedept" select="./@code"/>
             
              <li>
                <a href="#" class="narrow-results" id="{$thedept}">    
                <xsl:value-of select="current-grouping-key()"/> 
                <!-- count -->
                
                <xsl:for-each select="current-group()">
                  <xsl:if test="position()=last()">
                    <xsl:text> (</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text>
                  </xsl:if>
                </xsl:for-each>
                </a>
                <!-- group by course group -->
                <ul id="narrow-course_group" class="course_group">
                  <xsl:for-each-group select="current-group()" group-by="following-sibling::course_group">
                    <xsl:sort select="."/>
                    <xsl:variable name="group_code" select="following-sibling::course_group/@code"/>
                    <li>
                      <a href="#" class="narrow-results" id="{$group_code}">
                        <xsl:value-of select="current-grouping-key()"/>
                        <!-- count -->
                        <xsl:for-each select="current-group()">
                          <xsl:if test="position()=last()">
                            <xsl:text> (</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text>
                          </xsl:if>
                        </xsl:for-each>
                      </a>
                    </li>
                  </xsl:for-each-group>
                </ul>
                
              </li>
              
            </xsl:for-each-group>
          </ul>
        </div>
      </div>
    </div>
   </xsl:if>
    
    <!-- narrow by: term -->
    <xsl:if test="$term ='all'">
    <div>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><xsl:text>By term</xsl:text></h3>
        </div>
        <div class="panel-body">
          <ul id="narrow-term">
            <xsl:for-each-group select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]/term" group-by="@term_pattern_code"> 
              <xsl:sort select="@term_pattern_code"/>
              <xsl:variable name="term_code" select="./@term_pattern_code"/>
              <li><a href="#" class="narrow-results" id="{$term_code}">
                <xsl:value-of select="."/> 
                <!-- count -->
                <xsl:for-each select="current-group()">
                  <xsl:if test="position()=last()">
                    <xsl:text> (</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text>
                  </xsl:if>
                </xsl:for-each>    
                </a>      
              </li>
            </xsl:for-each-group>
          </ul>
        </div>
      </div>
    </div>
    </xsl:if>
    <!-- narrow by: instructor -->
    <xsl:if test="$faculty = 'all'">
    <div>
      <div class="panel panel-default">
        <div class="panel-heading">
           <h3 class="panel-title"><xsl:text>By instructor</xsl:text></h3>
        </div>
        <div class="panel-body">
          <div class="instructor"><xsl:text>All instructors (</xsl:text><xsl:value-of select="count(distinct-values(/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
            and ($dept = 'all' or department/@code=$dept)
            and ($course_group = 'all' or course_group/@code=$course_group)
            and($term = 'all' or term/@term_pattern_code=$term)
            and($day = 'all' or schedule/meeting/@day=$day)
            and($time = 'all' or schedule/meeting/@begin_time=$time)
            and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]/faculty_list/faculty/@id))"/>)
          </div>
          <ul id="narrow-faculty">
            <xsl:for-each-group select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]/faculty_list/faculty" group-by="@id">   
              <xsl:sort select="name/last"/>
              <xsl:variable name="f_id" select="./@id"/>
              <li>
                <a href="#" class="narrow-results" id="{$f_id}">
                  <xsl:value-of select="concat(name/first,' ', name/middle,' ', name/last)"/> 
                  <!-- count -->
                  <xsl:for-each select="current-group()">
                    <xsl:if test="position()=last()">
                      <xsl:text> (</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </a>
              </li>
            </xsl:for-each-group>
          </ul>
        </div>
      </div>
    </div>
    </xsl:if>
    <!-- narrow by: day -->
    <xsl:variable name="scheduled">
      <xsl:value-of select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
        and ($dept = 'all' or department/@code=$dept)
        and ($course_group = 'all' or course_group/@code=$course_group)
        and($term = 'all' or term/@term_pattern_code=$term)
        and($day = 'all' or schedule/meeting/@day=$day)
        and($time = 'all' or schedule/meeting/@begin_time=$time)
        and($faculty = 'all' or faculty_list/faculty/@id=$faculty)and schedule[(child::node())]]"/>
    </xsl:variable>
    <xsl:if test="$day ='all' and $scheduled !=''">
    <div>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><xsl:text>By day</xsl:text></h3>
        </div>
        <div class="panel-body">
          <ul id="narrow-day">
            <xsl:for-each-group select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]" group-by="schedule/meeting/@day">   
              <xsl:sort select="current-grouping-key()"/>
              <xsl:variable name="theday" select="current-grouping-key()"/> 
              
              <li> 
                <a href="#" class="narrow-results" id="{$theday}">
                    <xsl:if test="$theday='1'">
                      <xsl:text>M</xsl:text>
                    </xsl:if>
                    <xsl:if test="$theday='2'">
                      <xsl:text>T</xsl:text>
                    </xsl:if>
                    <xsl:if test="$theday='3'">
                      <xsl:text>W</xsl:text>
                    </xsl:if>
                    <xsl:if test="$theday='4'">
                      <xsl:text>Th</xsl:text>
                    </xsl:if>
                    <xsl:if test="$theday='5'">
                      <xsl:text>F</xsl:text>
                    </xsl:if>
                    <xsl:if test="$theday='6'">
                      <xsl:text>S</xsl:text>
                    </xsl:if>              
                  <!-- count -->
                 <xsl:for-each select="current-group()">
                    <xsl:if test="position()=last()">
                      <xsl:text> (</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                  </a>
                </li>
            </xsl:for-each-group>
       <!-- <li><xsl:call-template name="no_schedule"/></li> -->
          </ul>
        </div>
      </div>
    </div>
    </xsl:if>
    <!-- narrow by: time -->
   
    <xsl:if test="$time = 'all'and $scheduled !=''">
    <div>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><xsl:text>By time</xsl:text></h3>
        </div>
        <div class="panel-body">
          <ul id="narrow-time">
            <xsl:for-each-group select="/courses/course[($keyword='' or contains(translate(.,$uppercase, $lowercase), $mykeyword))
              and ($dept = 'all' or department/@code=$dept)
              and ($course_group = 'all' or course_group/@code=$course_group)
              and($term = 'all' or term/@term_pattern_code=$term)
              and($day = 'all' or schedule/meeting/@day=$day)
              and($time = 'all' or schedule/meeting/@begin_time=$time)
              and($faculty = 'all' or faculty_list/faculty/@id=$faculty)]" group-by="schedule/meeting/@begin_time">   
              <xsl:sort select="current-grouping-key()" data-type="number"/>
             
              <xsl:variable name="thetime" select="current-grouping-key()"/> 
              <li>
                <a href="#" class="narrow-results" id="{$thetime}">
                  <xsl:value-of /> 
                  <xsl:choose>
                    <xsl:when test="string-length($thetime) &gt; 3">
                      <xsl:value-of select="concat(substring($thetime,1,2),':',substring($thetime,3,4)) "></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat(substring($thetime,1,1),':',substring($thetime,2,3)) "/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-- count -->
                  <xsl:for-each select="current-group()">
                    <xsl:if test="position()=last()">
                      <xsl:text> (</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </a>          
              </li>
            </xsl:for-each-group>
          </ul>
        </div>
      </div>
    </div>
  </xsl:if>
  </xsl:template>

  <xsl:template match="text()" /> 
  
</xsl:stylesheet>