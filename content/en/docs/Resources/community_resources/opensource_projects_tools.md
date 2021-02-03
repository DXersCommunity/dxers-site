---
title: "Opensource projects"
linkTitle: "Opensource projects"
description: >
  Here is a curated list of opensource projects and repositories shared by professionals, partners, customers in the HCL DX Space
---

## Monitoring & performance

| Resource      | What it is |
|------|---------------|----|
| <pre><a href="https://github.com/2innovate/was-metrics-exporter" target="_blank" >was-metrics-exporter</a></pre>  | Retrieving traditional WebSphere Application Server (tWAS) performance data (PMI) via the MBeans is not trivial: the MBeans providing performance data are quite complex and therefore can't be retrieved using standard tools like e.g. Jolokia.<br><br>As an alternative way to retrieve PMI data, tWAS ships with a Performance Servlet-EAR which provides PMI data obtained from the runtime as XML data. A major drawback of performance servlet is that nowadays most modern metrics aggregation tools work with Json or plain text inputs (like InfluxDb) and don't support (complex) XML input directly.<br><br>The idea of this project is to provide a tool to fetch and transform PMI data from XML into multiple target formats. Additional output formats can easily be introduced by writing a new output plugin.<br><br>by <a href="https://2innovate.at/" taget="_blank" >https://2innovate.at/</a> |
