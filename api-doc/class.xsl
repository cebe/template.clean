<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dbx="http://docblox-project.org/xsl/functions">
  <xsl:output indent="yes" method="html"/>

  <!--
    template for class and interface "extends"
    @todo: find out what this does
  -->

  <xsl:template match="class/extends|interface/extends">
    <xsl:if test="not(.)">n/a</xsl:if>
    <xsl:if test=".">
      <xsl:if test="@link">
        <a href="{$root}{@link}"><xsl:value-of select="."/></a>
      </xsl:if>
      <xsl:if test="not(@link)">
        <xsl:if test=". = ''">?</xsl:if>
        <xsl:if test=". != ''">
          <xsl:value-of select="."/>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!--
    @todo: find out what this does
  -->

  <xsl:template name="class_inherit">
    <xsl:param name="class"/>
    <xsl:param name="depth"/>

    <a href="{concat($root, $class/../@generated-path, '#', $class/full_name)}">
      <xsl:if test="$depth != 0">
          <xsl:attribute name="style">color: gray; font-size: 0.8em
          </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$class/full_name"/>
    </a>

    <xsl:variable name="parent" select="$class/extends"/>
    <xsl:if test="/project/file/*[full_name=$parent]">
      &lt;
      <xsl:call-template name="class_inherit">
        <xsl:with-param name="class"
                        select="/project/file/*[full_name=$parent]"/>
        <xsl:with-param name="depth" select="$depth+1"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$parent != '' and not(/project/file/*[full_name=$parent])">
      &lt;
      <xsl:apply-templates select="$parent"/>
    </xsl:if>

  </xsl:template>

  <!--
    template for classes/interfaces

    generates the class documentation page with methods, properties etc...
  -->

  <xsl:template match="class|interface">
      <!-- class name headline -->
      <a id="{full_name}" class="anchor"/>
      <h2 class="{name()}">
          <xsl:value-of select="full_name"/>
          <div class="to-top">
              <a href="#top">jump to top</a>
          </div>
      </h2>

      <!-- all content of class docs -->

      <div class="class">

        <xsl:if test="docblock/description">
            <xsl:apply-templates select="docblock/description"/>
        </xsl:if>

        <dl class="class-info">

          <dt>Package</dt><dd><xsl:value-of select="@package"/></dd>

          <xsl:if test="implements">
              <dt>Implements</dt>
              <xsl:for-each select="implements">
                  <dd>
                      <xsl:if test="@link = ''">
                          <xsl:value-of select="."/>
                      </xsl:if>
                      <xsl:if test="@link != ''">
                          <a href="{@link}">
                              <xsl:value-of select="."/>
                          </a>
                      </xsl:if>
                  </dd>
              </xsl:for-each>
          </xsl:if>

          <xsl:if test="extends != ''">
              <dt>Parent(s)</dt>
              <dd>
                  <xsl:variable name="parent" select="extends"/>
                  <xsl:if test="/project/file/*[full_name=$parent]">
                      <xsl:call-template name="class_inherit">
                          <xsl:with-param name="class"
                                          select="/project/file/*[full_name=$parent]"/>
                          <xsl:with-param name="depth" select="0"/>
                      </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="not(/project/file/*[full_name=$parent])">
                      <xsl:apply-templates select="$parent"/>
                  </xsl:if>
              </dd>
          </xsl:if>

          <xsl:variable name="full_name" select="full_name"/>

          <xsl:if test="/project/file/*[extends=$full_name]">
              <dt>Children</dt>
              <xsl:for-each select="/project/file/*[extends=$full_name]">
                  <dd>
                      <a href="{concat($root, ../@generated-path, '#', full_name)}">
                          <xsl:value-of select="full_name"/>
                      </a>
                  </dd>
              </xsl:for-each>
          </xsl:if>

          <xsl:apply-templates select="docblock/tag[@name='see']"/>
          <xsl:apply-templates select="docblock/tag[@name != 'see' and @name != 'package' and @name != 'subpackage']">
              <xsl:sort select="dbx:ucfirst(@name)"/>
          </xsl:apply-templates>
      </dl>

      <xsl:if test="docblock/long-description">
          <xsl:apply-templates select="docblock/long-description"/>
      </xsl:if>

      <xsl:call-template name="doctrine"/>

      <!-- Property and method lists -->

      <xsl:if test="count(property) > 0">
          <h3>Properties</h3>
          <table class="methods">
            <tr>
              <th>Name</th><th>Type</th><th>Description</th><th>Default Value</th>
            </tr>
            <xsl:for-each select="property">
              <xsl:sort select="name" />
              <tr>
              <td style="padding-bottom: 2px;">
                <img src="./images/icons/property.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" />
                <xsl:if test="@visibility='private'">
                  <img src="./images/icons/constant.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" />
                </xsl:if>
                <xsl:if test="@visibility='protected'">
                  <img src="./images/icons/constant.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" />
                </xsl:if>
                <xsl:if test="@visibility='public'">
                  <!--img src="./images/icons/visibility_public.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" /-->
                  <span style="width: 16px; height: 16px; margin: 0 5px 0 0; display: inline-block;"></span>
                </xsl:if>

               <!--xsl:value-of select="@visibility" />&#160;-->

                <a href="#{../name}::{name}"><xsl:value-of select="name" /></a>
              </td>
              <td>
                  <xsl:value-of select="docblock/tag[@name='var']/@type" />&#160;
              </td>
              <td>
                  <xsl:value-of select="docblock/description" disable-output-escaping="yes" />
              </td>
              <td>
                  <xsl:if test="default">
                      <xsl:value-of select="default" />
                  </xsl:if>
              </td>
    <!--           <xsl:value-of select="@visibility" />&#160;
               <xsl:if test="@static='true'">static&#160;</xsl:if>
               <xsl:if test="@final='true'">final&#160;</xsl:if>
    -->
             </tr>
            </xsl:for-each>
          </table>
      </xsl:if>

            <xsl:if test="count(method) > 0">
                <h3>Methods</h3>

                <table class="methods">
                  <tr>
                    <th>Name</th><th>Type</th><th>Description</th><th>...</th>
                  </tr>
                <xsl:for-each select="method">
                  <xsl:sort select="name" />
                  <tr>
                    <td>
                      <img src="./images/icons/method.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" />
                      <xsl:if test="@visibility='private'">
                        <img src="./images/icons/constant.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" />
                      </xsl:if>
                      <xsl:if test="@visibility='protected'">
                        <img src="./images/icons/constant.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" />
                      </xsl:if>
                      <xsl:if test="@visibility='public'">
                        <!--img src="./images/icons/visibility_public.png" style="width: 16px; height: 16px; margin: 0 5px 0 0;" /-->
                        <span style="width: 16px; height: 16px; margin: 0 5px 0 0; display: inline-block;"></span>
                      </xsl:if>

                      <a href="#{../full_name}::{name}()"><xsl:value-of select="name" /></a>
                    </td>
                    <td>
                      <xsl:if test="not(docblock/tag[@name='return']/@type)">n/a</xsl:if>
                        <xsl:if test="docblock/tag[@name='return']/@type">
                          <xsl:if test="docblock/tag[@name='return']/@link">
                            <a href="{$root}{docblock/tag[@name='return']/@link}">
                              <xsl:value-of select="docblock/tag[@name='return']/@type" />
                            </a>
                          </xsl:if>
                          <xsl:if test="not(docblock/tag[@name='return']/@link)">
                            <xsl:value-of select="docblock/tag[@name='return']/@type" />
                          </xsl:if>
                        </xsl:if>
                    </td>
                    <td><xsl:value-of select="docblock/description" disable-output-escaping="yes" /></td>
                    <td>
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



                    </td>
                  </tr>
                </xsl:for-each>
                </table>
            </xsl:if>


            <xsl:if test="count(constant) > 0">
                <h3>Constants</h3>
                <div>
                    <xsl:apply-templates select="constant"/>
                </div>
            </xsl:if>

            <xsl:if test="count(property) > 0">
                <h3>Properties</h3>
                <div>
                    <xsl:apply-templates select="property">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>

            <xsl:if test="count(method) > 0">
                <h3>Methods</h3>
                <div>
                    <xsl:apply-templates select="method">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </div>

    </xsl:template>

</xsl:stylesheet>
