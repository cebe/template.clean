<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dbx="http://docblox-project.org/xsl/functions">


  <xsl:template match="property">
    <a id="{../full_name}::{name}" class="anchor"/>

    <div>
        <xsl:attribute name="class">
            <xsl:value-of select="concat(name(), ' ', @visibility)"/>
            <xsl:if test="inherited_from"> inherited_from </xsl:if>
            <xsl:if test="docblock/tag[@name='magic']"> magic </xsl:if>
        </xsl:attribute>

        <code>
            <img src="{$root}images/icons/property.png" alt="Property"/>
            <xsl:if test="@visibility">
                <img src="{$root}images/icons/visibility_{@visibility}.png" style="margin-right: 5px" alt="{@visibility}"/>
            </xsl:if><xsl:if test="docblock/tag[@name='var']/@type">
            <xsl:apply-templates select="docblock/tag[@name='var']/@type"/></xsl:if>
            &#160;<span class="highlight"><xsl:value-of select="name"/></span>
            <xsl:if test="default">= '<xsl:value-of select="default"/>'
            </xsl:if>
        </code>

        <div class="description">
            <xsl:if test="@static='true'">
                <span class="attribute">static</span>
            </xsl:if>

            <xsl:if test="@final='true'">
                <span class="attribute">final</span>
            </xsl:if>

            <xsl:if test="inherited_from">
                <span class="attribute">inherited</span>
            </xsl:if>

            <xsl:apply-templates select="docblock/description|docblock/tag[@name='var']/@description"/>

            <xsl:if test="inherited_from">
                <small>Inherited from:
                    <xsl:apply-templates
                            select="docblock/tag[@name='inherited_from']/@link"/>
                </small>
            </xsl:if>
        </div>

      <em>
        <xsl:value-of select="docblock/description" disable-output-escaping="yes" />
        <xsl:value-of select="docblock/tag[@name='var']/@description" disable-output-escaping="yes" />

      </em>
      <xsl:if test="docblock/long-description">
        <br />
        <small>
          <xsl:value-of select="docblock/long-description" />
        </small>
        <br />
      </xsl:if>
      <br />

      <dl class="property-info">
          <dt>Type</dt>
          <dd>
              <xsl:if test="not(docblock/tag[@name='var']/type)">n/a</xsl:if>
              <xsl:if test="docblock/tag[@name='var']/type">
                  <xsl:call-template name="implodeTypes">
                      <xsl:with-param name="items" select="docblock/tag[@name='var']/type"/>
                  </xsl:call-template>
              </xsl:if>
          </dd>
          <xsl:apply-templates select="docblock/tag[@name!='var']">
              <xsl:sort select="dbx:ucfirst(@name)"/>
          </xsl:apply-templates>
      </dl>

      <div class="clear"></div>
    </div>

  </xsl:template>

</xsl:stylesheet>
