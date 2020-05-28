import flask
import random
from lxml import etree
from datetime import datetime

app = flask.Flask(__name__)

@app.route('/matmul.xsl')
def matumul_xslt():
    with open('./matmul.xsl', 'r') as f:
        return flask.Response(f.read(), mimetype='application/xml')

@app.route('/matmul/<n>')
def matmul(n):
    try:
        n = int(n)
        a = []
        for i in range(n):
            a.append([])
            for j in range(n):
                a[i].append(int(random.random()*2))
        b = []
        for i in range(n):
            b.append([])
            for j in range(n):
                b[i].append(int(random.random()*2))
        a_tree = etree.Element('a')
        for row in a:
            row_tree = etree.Element('row')
            for val in row:
                col = etree.Element('col')
                val_tree = etree.Element('val')
                val_tree.text = str(val)
                col.append(val_tree)
                row_tree.append(col)
            a_tree.append(row_tree)
        b_tree = etree.Element('b')
        for row in b:
            row_tree = etree.Element('row')
            for val in row:
                col = etree.Element('col')
                val_tree = etree.Element('val')
                val_tree.text = str(val)
                col.append(val_tree)
                row_tree.append(col)
            b_tree.append(row_tree)
        root = etree.Element('multiplication')
        root.append(a_tree)
        root.append(b_tree)
        time_tree = etree.Element('time')
        time_tree.text = str(datetime.now())
        root.append(time_tree)
        tree_str = etree.tostring(root, xml_declaration=False)
        out = f'<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/matmul.xsl"?>{tree_str.decode("utf-8")}'
        return flask.Response(out, mimetype="application/xml")
    except Exception as err:
        return flask.Response(str(err), status=400)

if __name__ == "__main__":
    app.run(debug=True)