<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common">

<xsl:template match="/">
  <html>
  <body>
    <h2 id="startTime"><xsl:value-of select="/multiplication/time" /></h2>
    <h3>a x b</h3>
    <table border="1">
        <xsl:for-each select="/multiplication/a/row">
            <xsl:variable name="a-row" select="position()" />
            <tr>
                <xsl:for-each select="/multiplication/b/row">
                    <xsl:if test="position() = 1">
                        <xsl:for-each select="col">
                            <td>
                                <xsl:variable name="to-sum">
                                    <xsl:variable name="col-pos" select="position()" />
                                    <xsl:for-each select="/multiplication/a/row">
                                        <xsl:if test="$a-row = position()">
                                            <xsl:for-each select="col">
                                                <xsl:variable name="a-col" select="position()"/>
                                                <xsl:variable name="a-val" select="val"/>
                                                <xsl:for-each select="/multiplication/b/row">
                                                    <xsl:if test="position() = $a-col">
                                                        <xsl:for-each select="col">
                                                            <xsl:if test="position() = $col-pos">
                                                                <xsl:element name="x">
                                                                    <xsl:value-of select="val * $a-val" />
                                                                </xsl:element>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:value-of select="sum(exsl:node-set($to-sum)/x)" />
                            </td>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </tr>
        </xsl:for-each>
    </table>
    <script>
        let start_time = Date.parse(document.getElementById('startTime').innerHTML);
        let now = Date.now()
        let took = Math.abs(now - start_time);
        document.getElementById('startTime').innerHTML = "Took " + took + "ms";
    </script>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet> 