<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="html" />
  <xsl:include href="chrome.xsl" />
  <xsl:include href="api-doc/property.xsl" />
  <xsl:include href="api-doc/class.xsl" />
  <xsl:include href="api-doc/constant.xsl" />
  <xsl:include href="api-doc/function.xsl" />
  <xsl:include href="api-doc/docblock.xsl" />
  <xsl:include href="api-doc/file.xsl" />

  <xsl:template match="/project" name="file">
    <div id="content">
      <xsl:apply-templates select="/project/file[@path=$path]" />
    </div>
    <small class="footer">Documentation was generated by <a href="http://docblox-project.org">DocBlox <xsl:value-of select="$version" /></a>.
    </small>
  </xsl:template>

</xsl:stylesheet>
