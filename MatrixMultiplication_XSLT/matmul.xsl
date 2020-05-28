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
                <xsl:for-each select="/multiplication/b/row[position() = 1]/col">
                    <xsl:variable name="col-pos" select="position()" />
                    <td>
                        <!-- Cell $a-row, $col-pos of axb -->
                        <xsl:variable name="to-sum">
                            <!-- for all values of the $a-rowth row of a -->
                            <xsl:for-each select="/multiplication/a/row">
                                <xsl:if test="$a-row = position()">
                                    <xsl:for-each select="col">
                                        <xsl:variable name="a-col" select="position()"/>
                                        <xsl:variable name="a-val" select="val"/>
                                        <!-- for all values of the $col-posth col of b -->
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
                        <!-- sum of the products selected before -->
                        <xsl:value-of select="sum(exsl:node-set($to-sum)/x)" />
                    </td>
                </xsl:for-each>
                <!-- end for-each cell of output -->
            </tr>
        </xsl:for-each>
        <!-- end for-each row of output -->
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