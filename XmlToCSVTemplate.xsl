<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 6, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> trey.kirk</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text"/>
    <xsl:variable name="n">
        <xsl:text>
</xsl:text> <!-- this format is on purpose-->
    </xsl:variable>
    
    <!-- how do I define my columns? I need to declar interesting elements and interesting attributes.
            - We need to know what elements to capture
            - Whether we stay on the same level as the selected elements or go into sub-elements
            - what to output
        
        
        - Really don't think writing this in XSLT is the solution. It's better in addressing specific use-cases, not a generic
          need. I should write this in a program and maybe improve upon the previous iteration.
        -->
</xsl:stylesheet>