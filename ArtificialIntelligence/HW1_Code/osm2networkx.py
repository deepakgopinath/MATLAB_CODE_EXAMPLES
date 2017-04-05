"""
Read graphs in Open Street Maps osm format

Based on osm.py from brianw's osmgeocode
http://github.com/brianw/osmgeocode, which is based on osm.py from
comes from Graphserver:
http://github.com/bmander/graphserver/tree/master and is copyright (c)
2007, Brandon Martin-Anderson under the BSD License
"""


import xml.sax
import copy
import networkx

def download_osm(left,bottom,right,top):
    """ Return a filehandle to the downloaded data."""
    from urllib import urlopen
    fp = urlopen( "http://api.openstreetmap.org/api/0.5/map?bbox=%f,%f,%f,%f"%(left,bottom,right,top) )
    return fp

def read_osm(filename_or_stream, only_roads=True):
    """Read graph in OSM format from file specified by name or by stream object.

    Parameters
    ----------
    filename_or_stream : filename or stream object

    Returns
    -------
    G : Graph

    Examples
    --------
    >>> G=nx.read_osm(nx.download_osm(-122.33,47.60,-122.31,47.61))
    >>> plot([G.node[n]['data'].lat for n in G], [G.node[n]['data'].lon for n in G], ',')

    """
    osm = OSM(filename_or_stream)
    G = networkx.Graph()

    for w in osm.ways.itervalues():
        if only_roads and 'highway' not in w.tags: # if only roads were requested and the keyword 'highway' is not in each of the Way object in the ways dictionary then skip it and continue on.
            continue
        G.add_path(w.nds, id=w.id, data=w) 
    for n_id in G.nodes_iter():
        n = osm.nodes[n_id]
        G.node[n_id] = dict(data=n)
    return G


class Node:
    def __init__(self, id, lon, lat):
        self.id = id
        self.lon = lon
        self.lat = lat
        self.tags = {}

class Way:
    def __init__(self, id, osm):
        self.osm = osm
        self.id = id
        self.nds = [] # list of nodes
        self.tags = {} # tags for the type of connections?


    def split(self, dividers):
        # slice the node-array using this nifty recursive function
        def slice_array(ar, dividers):
            for i in range(1,len(ar)-1):
                if dividers[ar[i]]>1:
                    #print "slice at %s"%ar[i]
                    left = ar[:i+1]
                    right = ar[i:]

                    rightsliced = slice_array(right, dividers)

                    return [left]+rightsliced
            return [ar]

        slices = slice_array(self.nds, dividers)

        # create a way object for each node-array slice
        ret = []
        i=0
        for slice in slices:
            littleway = copy.copy( self )
            littleway.id += "-%d"%i
            littleway.nds = slice
            ret.append( littleway )
            i += 1

        return ret



class OSM:
    def __init__(self, filename_or_stream):
        """ File can be either a filename or stream/file object."""
        nodes = {} # this is a dictionary
        ways = {}

        superself = self

        class OSMHandler(xml.sax.ContentHandler): #this is the callback. when the xml.sax.parser starts looking at an xml file, various callback functions are called. 
            @classmethod
            def setDocumentLocator(self,loc):
                pass

            @classmethod
            def startDocument(self):
                pass

            @classmethod
            def endDocument(self):
                pass

            @classmethod
            # self.currElem is an variable of class OSM
            def startElement(self, name, attrs): # When the start of an element in non-namepsace mode is encountered this method is called by the xml.sax parser.  
                if name=='node': # node is the xml element name and
                    self.currElem = Node(attrs['id'], float(attrs['lon']), float(attrs['lat'])) # and attrs is dictionary (key-value pair) containing the various attributes of the xml element. 
                elif name=='way':
                    self.currElem = Way(attrs['id'], superself) # superself can be accessed here because the class OSMHandler is in the same scope as 'superself'
                elif name=='tag':
                    self.currElem.tags[attrs['k']] = attrs['v'] # it is guarenteed that by the time this elif is executed, self.currElem is either a Node or Way object!
                elif name=='nd':
                    self.currElem.nds.append( attrs['ref'] ) # only for Way object!

            @classmethod
            def endElement(self,name): # this is called when the end of an element is reached. One can then add the element into the dictionary according to the id number. 
                if name=='node':
                    nodes[self.currElem.id] = self.currElem # the self.currElem can be a Node object or a WAy object. and 'nodes' and 'ways' are two dictionaries
                elif name=='way':
                    ways[self.currElem.id] = self.currElem # the thing in the square brackets is the 'key' and the right hand side is the value!

            @classmethod
            def characters(self, chars):
                pass

        xml.sax.parse(filename_or_stream, OSMHandler) # at the class OSM level. using a parser to parse through a osm filename or stream

        #after the previous code statement the xml would have been parsed and the nodes and ways dictionaries would have been populated. 
        self.nodes = nodes
        self.ways = ways

        #count times each node is used
        #print self.nodes.keys()
        node_histogram = dict.fromkeys( self.nodes.keys(), 0 ) # self.node.keys() is a list of node ids
        for way in self.ways.values(): # this is a list of Way objects
            if len(way.nds) < 2:       #if a way has only one node, delete it out of the osm collection
                del self.ways[way.id]
            else:
                for node in way.nds:
                    node_histogram[node] += 1

        #use that histogram to split all ways, replacing the member set of ways
        new_ways = {}
        for id, way in self.ways.iteritems():
            split_ways = way.split(node_histogram)
            for split_way in split_ways:
                new_ways[split_way.id] = split_way
        self.ways = new_ways
