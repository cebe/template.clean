<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dbx="http://docblox-project.org/xsl/functions">
  <xsl:output indent="yes" method="html" />

  <xsl:template match="method/name">
    <h4 class="method {../@visibility}">
      <img src="{$root}images/icons/visibility_{../@visibility}.png" style="margin-right: 10px" alt="{@visibility}"/>
      <xsl:value-of select="." />
      <div class="to-top"><a href="#{../../name}">jump to class</a></div>
    </h4>
  </xsl:template>

  <xsl:template match="function/name">
    <h3 class="function {../@visibility}">
      <img src="{$root}images/icons/visibility_{../@visibility}.png" style="margin-right: 10px" alt="{@visibility}"/>
      <xsl:value-of select="." />
      <div class="to-top"><a href="#top">jump to top</a></div>
    </h3>
  </xsl:template>

  <xsl:template match="argument">
      <xsl:variable name="name" select="name"/>
      <tr>
          <th>
              <xsl:value-of select="$name"/>
          </th>
          <td>
              <xsl:if test="../docblock/tag[@name='param' and @variable=$name]/type">
                  <xsl:call-template name="implodeTypes">
                      <xsl:with-param name="items" select="../docblock/tag[@name='param' and @variable=$name]/type"/>
                  </xsl:call-template>
              </xsl:if>
          </td>
          <td>
              <em>
                  <xsl:value-of select="../docblock/tag[@name='param' and @variable=$name]/@description" disable-output-escaping="yes"/>
              </em>
          </td>
      </tr>
  </xsl:template>

  <xsl:template match="function|method">
    <a id="{../full_name}::{name}()" class="anchor" />
    <div class="method">
        <xsl:attribute name="class">
            <xsl:value-of select="concat(name(), ' ', @visibility)" />
            <xsl:if test="inherited_from"> inherited_from </xsl:if>
        </xsl:attribute>

        <a id="{../name}::{name}()" />

        <code>
            <img src="{$root}images/icons/{name()}.png" alt="{name()}"/>
            <xsl:if test="@visibility">
                <img src="{$root}images/icons/visibility_{@visibility}.png" style="margin-right: 5px" alt="{@visibility}"/>
            </xsl:if>
            <span class="highlight"><xsl:value-of select="name" /></span>

          <span class="nb-faded-text">(
            <xsl:for-each select="argument">
              <xsl:if test="position() &gt; 1">, </xsl:if>

              <xsl:variable name="variable_name" select="name" />

              <xsl:call-template name="implodeTypes">
                <xsl:with-param name="items" select="../docblock/tag[@name='param' and @variable=$variable_name]/type" />
              </xsl:call-template>&#160;<xsl:value-of select="$variable_name" />

              <xsl:if test="default != ''">
                =
                <xsl:value-of select="default" disable-output-escaping="yes" />
              </xsl:if>
            </xsl:for-each>
            )
          </span>
          :
            <xsl:if test="not(docblock/tag[@name='return'])">void</xsl:if>
            <xsl:apply-templates select="docblock/tag[@name='return']" />
        </code>

        <xsl:if test="@static='true'">
          <span class="attribute">static</span>
        </xsl:if>

        <xsl:if test="@final='true'">
          <span class="attribute">final</span>
        </xsl:if>

        <xsl:if test="@abstract='true'">
          <span class="attribute">abstract</span>
        </xsl:if>

        <xsl:if test="inherited_from">
          <span class="attribute">inherited</span>
        </xsl:if>

        <xsl:if test="inherited_from">
          <small>Inherited from:
            <xsl:if test="docblock/tag[@name='inherited_from']/@link">
            <xsl:apply-templates select="docblock/tag[@name='inherited_from']/@link"/>
            </xsl:if>

            <xsl:if test="not(docblock/tag[@name='inherited_from']/@link)">
            <xsl:value-of select="docblock/tag[@name='inherited_from']/@description" />
            </xsl:if>
          </small>
        </xsl:if>

        <table class="params">
          <!--tr><th>Name</th><th>Type</th><th>Description</th><th>Default</th></tr-->
          <tbody>
            <xsl:for-each select="argument">
              <xsl:variable name="variable_name" select="name" />
              <xsl:variable name="variable_description" select="../docblock/tag[@name='param' and @variable=$variable_name]/@description" />
              <tr>
                <td width="15%">
                  <xsl:value-of select="$variable_name" />
                </td>
                <td style="white-space: normal;" width="10%">
                  <xsl:if test="not(../docblock/tag[@name='param' and @variable=$variable_name]/type)">n/a</xsl:if>
                  <xsl:for-each select="../docblock/tag[@name='param' and @variable=$variable_name]/type">
                    <xsl:if test="position() &gt; 1">|</xsl:if>
                    <xsl:if test="@link"><a href="{$root}{@link}"><xsl:value-of select="." /></a></xsl:if>
                    <xsl:if test="not(@link)"><xsl:value-of select="." /></xsl:if>
                  </xsl:for-each>
                </td>
                <td width="60%">
                  <xsl:value-of select="$variable_description" disable-output-escaping="yes"/>
                </td>
                <td width="15%">
                  <xsl:value-of select="default" disable-output-escaping="yes" />
                </td>
              </tr>
            </xsl:for-each>
          <!--/tbody>
        </table>
        </xsl:if>

        <h4>Return value</h4>
        <table>
          <thead>
          </thead>
          <tbody-->
            <tr>
              <td width="15%"><b>@return</b></td>
              <td width="10%">
                <xsl:apply-templates select="docblock/tag[@name='return']"/>
              </td>
              <td width="75%" colspan="2">
                <xsl:apply-templates select="docblock/tag[@name='return']/@description"/>
              </td>
            </tr>
          </tbody>
        </table>

        <!--xsl:if test="docblock/description != '' or docblock/long-description != ''">
           <h4>Description</h4>
        </xsl:if-->
        <xsl:if test="docblock/description != ''">
           <em><xsl:value-of select="docblock/description" /></em><br />
        </xsl:if>
        <xsl:if test="docblock/long-description != ''">
           <small><xsl:value-of select="docblock/long-description" disable-output-escaping="yes" /></small><br />
        </xsl:if>

        <xsl:if test="count(docblock/tag[@name = 'throws'])">
            <strong>Throws</strong>
            <table class="argument-info">
              <thead>
                <tr>
                  <th>Exception</th>
                <th>Description</th>
              </tr>
            </thead>
            <xsl:apply-templates select="docblock/tag[@name='throws']"/>
          </table>
        </xsl:if>

        <xsl:call-template name="doctrine" />

        <xsl:if test="docblock/tag[@name != 'param' and @name != 'return' and @name !='inherited_from' and @name != 'throws']">
          <strong>Details</strong>
          <dl class="function-info">
            <xsl:apply-templates select="docblock/tag[@name != 'param' and @name != 'return' and @name !='inherited_from' and @name != 'throws']">
              <xsl:sort select="dbx:ucfirst(@name)"/>
            </xsl:apply-templates>
          </dl>
        </xsl:if>

        <div class="clear"></div>
    </div>

  </xsl:template>

</xsl:stylesheet>
