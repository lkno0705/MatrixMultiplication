# XSLT in the browser
This implementation uses flask to host a debug webserver. The webserver returns random matrices a and b in XML-Format with a link to the corresponding XSLT to. To try it out, start the webserver and navigate to `localhost:5000/matmul/n` where n is your desired matrix size. A trick is used to easily calculate total time taken, the current time is sent by the webbrowser after initializing to matrices and JavaScript-Code embedded in the XSLT, that is executed only after the browser executed the XSLT, uses this information to calculate the time difference.

If benchmarking, first run with a small size of e.g. 20 so the browser caches the XSLT, as requesting it can take up to 500ms.

It was tested under Chrome and Firefox only.

### Requirements:
- Python
- flask
- lxml
- Web Browser