<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:param name="url" />
    <xsl:param name="baselink" />
    <xsl:param name="querystring" />
    <xsl:param name="keyword" />
    <xsl:param name="dept" select="'all'"/>
    <xsl:param name="course_group" select="'all'"/>
    <xsl:param name="term" select="'all'"/>
    <xsl:param name="day" select="'all'"/>
    <xsl:param name="time" select="'all'"/>
    <xsl:param name="faculty" select="'all'"/>
    <xsl:param name="cat_num" />
    <xsl:param name="sort" />
    <xsl:param name="page" />
    <xsl:variable name="title" select="'Harvard University Course Catalog'"></xsl:variable>
  
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:variable name="mykeyword">
        <xsl:value-of select="translate($keyword, $uppercase, $lowercase)" />
    </xsl:variable>
  
  <xsl:template match="/">
      <xsl:apply-templates />
  </xsl:template>
    
</xsl:stylesheet>