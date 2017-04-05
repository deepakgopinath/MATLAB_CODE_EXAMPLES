from osm2networkx import *
import random
from heapq import *
from math import *

"""
Searching a street network using Breadth First Search

REQUIREMENTS:

  networkx: http://networkx.github.io/

REFERENCES:

  [1] Russel, Norvig: "Artificial Intelligene A Modern Approach", 3rd ed, Prentice Hall, 2010

ASSIGNMENT:

  Extend this program to Tridirectional Search.
  Find a path between three starting points.

author: Daniel Kohlsdorf and Thad Starner
"""

"""
The state space in our problem hold:

   1) A node in the street graph
   2) A parent node

"""
class State:

    def __init__(self, node, parent):
        self.node   = node  # is of type Node
        self.parent = parent # is  of type State

    def __eq__(self, other):
        if isinstance(other, State):
            return self.node['data'].id == other.node['data'].id
        return NotImplemented

"""
Implements BFS on our GPS data

see [1] Figure 3.11
"""
def bfs(graph, start, goal):
    if start == goal:
        print "START === GOAL"
        return None
    
    frontier = [start] # start is of type "State",
    explored = [] # is also a list of States!
    num_explored = 0
    while len(frontier) > 0:
       node = frontier.pop(0) # always pop the oldest node in the frontier. In Uniform cost, the frontier is ordered in such a way that the list is sorted according to the lowest path cost. 
       # node is of type State:
       explored.append(node)
       for edge in networkx.edges(graph, node.node['data'].id):
           child = State(graph.node[edge[1]], node)   # edge[1] is the second number in the tuple, which is the destination node
           if (child not in explored) and (child not in frontier):
               # HINT: Goal - Check
               if child == goal:
                   print "Goal found, explored: ", num_explored, "\n\n"
                   return child
               else:
                   frontier.append(child) # a child is always added to the end of the frontier queue. 
               num_explored = num_explored + 1
    print "No path found, explored: ", num_explored

    return None

"""Implements Uniform Cost Search on our GPS data

"""


"""

The distance metric is the euclidean distance. The path cost is the sum of step costs. The step cost between two nodes is the 
euclidean distance between the two nodes. 

g(n') = step(n,n') + g(n), where n' is the child of n. 
g(start) = 0

The
"""

def uniform_cost_search(graph, start, goal):
  if start == goal:
    print "START === GOAL"
    return None, 0, 0

  frontier = [] # regular list. Will be heapified
  heapify(frontier)
  heappush(frontier, (0, start)) # the elements in the frontier list are tuples, the first element is the priority metric which is the path cost. The second element IS the state object
 
  distances = {start.node['data'].id : 0} # dictionary of path costs for each state. 

  explored = [] # is a list of State objects
  num_explored = 0

  while len(frontier) > 0:
    node = heappop(frontier)[1] #the second element of the tuple is the State Object we are interested in

    if node == goal: # goal test. The equality for State objects have been defined in the class. 
      print "Goal found, explored states  =", num_explored, 
      return node , distances[node.node['data'].id], num_explored #this is the path cost to that node. this is should be minimum. 

    explored.append(node) # add the popped node to the explored set. 
    for edge in networkx.edges(graph, node.node['data'].id):
      child = State(graph.node[edge[1]], node) # create children and make State objects out of them. 
      if(child not in explored): # easy check for child in explored set. 
        alt = find_euclidean_dist(child.parent.node, child.node) + distances[child.parent.node['data'].id]  
        if(child not in [x[1] for x in frontier]): # check whether the child object is in frontier. but frontier is a tuple. which is why we have a nested enumeration
          heappush(frontier, (alt,child)) # push the new child to the frontier. 
          distances[child.node['data'].id] = alt # this will be newly created in the dictionary
          heapify(frontier) # make sure it is ordered. 
        else: # if the child is in the frontier then see if it has higher path cost.
          if(alt < distances[child.node['data'].id]): 
            index = frontier.index((distances[child.node['data'].id], child)) # find index of the node thats to be removed
            distances[child.node['data'].id] = alt # update the distance dict
            frontier.pop(index) # remove the old node.
            heapify(frontier) # heapify
            heappush(frontier, (alt, child)) # push the child node with new path cost
        num_explored = num_explored + 1


  print "Num explored = " ,num_explored
  return None, 0, num_explored


  
def bidirectional_search(graph, start, goal): # ucs version
  if start == goal:
    print "Start = goal"
    return None, None, 0, 0

  frontiers =[ [], []]
  for x in frontiers:
    heapify(x)
  heappush(frontiers[0], (0, start)) # initialize both the frontiers with start and end tuples. 
  heappush(frontiers[1], (0, goal)) 

  explored = [ [], [] ]
  distances = [{start.node['data'].id : 0},{goal.node['data'].id : 0}] # path cost for two separate searches

  frontSearch = True
  backSearch = True

  popNode = None
  prpNode = None

  num_explored = 0
  while (len(frontiers[0]) > 0 and len(frontiers[1]) > 0):
  # print "Inside while"
  #forward search
    if(len(frontiers[0]) > 0 and frontSearch):
      nodeFwd = heappop(frontiers[0])[1] # this is a State Object, when this is popped it is guarenteed to have found the optimal path to nodeFwd
      if(isinstance(prpNode, State)):
        if(nodeFwd.node['data'].id == prpNode.node['data'].id):
          print "Number explored in BDS", num_explored
          return nodeFwd, prpNode, distances[0][nodeFwd.node['data'].id] + distances[1][prpNode.node['data'].id], num_explored

      explored[0].append(nodeFwd)
      for edge in networkx.edges(graph, nodeFwd.node['data'].id):
        childFwd = State(graph.node[edge[1]] ,nodeFwd) # create the child from the parent
        if (childFwd not in explored[0]):
            altFwd = find_euclidean_dist(childFwd.parent.node, childFwd.node) + distances[0][childFwd.parent.node['data'].id]
            if(childFwd not in (x[1] for x in frontiers[0])):
              heappush(frontiers[0], (altFwd, childFwd))
              distances[0][childFwd.node['data'].id] = altFwd
              heapify(frontiers[0])
            else:
              if(altFwd < distances[0][childFwd.node['data'].id]):
                indexFwd = frontiers[0].index((distances[0][childFwd.node['data'].id], childFwd))
                distances[0][childFwd.node['data'].id] = altFwd
                frontiers[0].pop(indexFwd)
                heapify(frontiers[0])
                heappush(frontiers[0], (altFwd, childFwd))
            num_explored = num_explored + 1
    else:
      nodeFwd = None 

    # backward search
    if(len(frontiers[1]) > 0 and backSearch):
      nodeBwd = heappop(frontiers[1])[1]
      if(isinstance(popNode, State)):
        if(nodeBwd.node['data'].id == popNode.node['data'].id):
          print "Number explored in BDS", num_explored
          return popNode, nodeBwd, distances[0][popNode.node['data'].id] + distances[1][prpNode.node['data'].id], num_explored

      explored[1].append(nodeBwd)
      for edge in networkx.edges(graph, nodeBwd.node['data'].id): # this can be done because of the undirected nature of the graph.
        childBwd = State(graph.node[edge[1]], nodeBwd)
        if(childBwd not in explored[1]):
          altBwd = find_euclidean_dist(childBwd.parent.node, childBwd.node) + distances[1][childBwd.parent.node['data'].id]
          if(childBwd not in (x[1] for x in frontiers[1])):
            heappush(frontiers[1], (altBwd, childBwd))
            distances[1][childBwd.node['data'].id] = altBwd
            heapify(frontiers[1])
          else:
            if(altBwd < distances[1][childBwd.node['data'].id]):
              indexBwd = frontiers[1].index((distances[1][childBwd.node['data'].id], childBwd))
              distances[1][childBwd.node['data'].id] = altBwd
              frontiers[1].pop(indexBwd)
              heapify(frontiers[1])
              heappush(frontiers[1], (altBwd, childBwd))
          num_explored = num_explored + 1
    else:
      nodeBwd = None


    # now check if the frontiers meet?

    if(nodeFwd != None and nodeBwd != None):
      matchFound = False
      if(matchFound == False):
        for x in frontiers[0]: # forward search frontier. each x is a tuple
          if(x[1] == nodeBwd):
            matchFound = True
            popNode = x[1]
            prpNode = nodeBwd
            whichOptimal = 0 # second half is optimal
            backSearch = False
            frontSearch = True
            break

      if(matchFound == False):
        for x in frontiers[1]: # backwards search frontier. each x is a tuple. x[1] is the state object
          if(x[1] == nodeFwd):
            matchFound = True
            popNode = nodeFwd
            prpNode = x[1]
            whichOptimal = 1 # first half is optimal
            backSearch = True
            frontSearch = False
            break

      if(matchFound == False):
        if(nodeFwd == nodeBwd):
          matchFound = True
          popNode = nodeFwd
          prpNode = nodeBwd
          whichOptimal = 2  # total is optimal
          backSearch = False
          frontSearch = False

      # if(popNode != None and prpNode != None):
      #   print "Which Optimal ", whichOptimal
      #   return popNode, prpNode

      if(backSearch == False and frontSearch == False):
        print "Number explored", num_explored
        return popNode, prpNode, distances[0][popNode.node['data'].id] +  distances[1][prpNode.node['data'].id], num_explored
        
    if(nodeFwd != None and nodeFwd == goal):
      print "Number explored", num_explored
      return nodeFwd, None, distances[0][nodeFwd.node['data'].id], num_explored

    if(nodeBwd != None and nodeBwd == start):
      print "Number explored", num_explored
      return None, nodeBwd, distances[1][nodeBwd.node['data'].id], num_explored


  print "No intersection"
  return None, None, 0, num_explored
  



# helper function to find euclidean distance between two points. 
def find_euclidean_dist(start, end): # start and end are Nodeobjects
  R = 6378000 # radius of earth in meters. To avoid low precision errors. Any large constant would still work. 
  if start == end:
    return 0
  else:
    lat1 = radians(float(start['data'].lat))
    lon1 = radians(float(start['data'].lon))
    lat2 = radians(float(end['data'].lat))
    lon2 = radians(float(end['data'].lon))

    euclidean_dist2 = (R**2)*(2 - 2*cos(lat1)*cos(lat2)*cos(lon1-lon2) - 2*sin(lat1)*sin(lat2)) # this multipled by R the radius of earth is the square of the euclidean distance
    return euclidean_dist2
"""
Backtrack and output your solution
"""

def tridirectional_search(graph, stateOne, stateTwo, stateThree):
  """
  I am intepreting tridirectional search as running 3 bds in parallel. The advantage of parallel BDS as opposed to serial is that
  with parallel we will be expanding the frontier once where as for seirl
  """
  if((stateOne == stateTwo) and (stateOne == stateThree)): # all three points are the same
    print "All three states are actually the same city"
    return None, None, None, None, None, None, 0, 0, 0, 0  # this might change
  if(stateOne == stateTwo):
    state, cost, numExploredUCS  = uniform_cost_search(graph, stateOne, stateThree) # reduces to a two city problem
    return state, None, None, None, None, None, cost, 0, 0, numExploredUCS
  if(stateOne == stateThree):
    state, cost, numExploredUCS = uniform_cost_search(graph, stateOne, stateThree)
    return state, None, None, None, None, None, cost, 0, 0, numExploredUCS
  if(stateTwo == stateThree):
    state, cost, numExploredUCS = uniform_cost_search(graph, stateTwo, stateThree)
    return  state, None, None, None, None, None, cost, 0, 0, numExploredUCS

  frontiers = [[],[],[]]
  for x in frontiers:
    heapify(x)
  
  heappush(frontiers[0], (0, stateOne)) # initialize all the frontiers with start and end tuples. 
  heappush(frontiers[1], (0, stateTwo)) 
  heappush(frontiers[2], (0, stateThree))

  explored = [ [], [], [] ]
  #distances = [{stateOne.node['data'].id : 0},{stateTwo.node['data'].id : 0}, {stateThree.node['data'].id : 0}] # distances of 
  distances = [{stateOne.node['data'].id : 0} ,{stateTwo.node['data'].id : 0}, {stateThree.node['data'].id : 0}]

  # 12 and 21 and equivalent to fwdSearch and backSearch between 1 and 2.
  # similary 23 and 32, and 13 and 31
  direction12 = True
  direction13 = True
  direction21 = True
  direction23 = True
  direction31 = True
  direction32 = True 

  popNode12 = None
  prpNode12 = None
  popNode13 = None
  prpNode13 = None
  popNode23 = None
  prpNode23 = None

  num_explored = 0
  result = [1,1,1,1,1,1] # dummy variables to store resultant nodes


  while (len(frontiers[0]) > 0 and len(frontiers[1]) > 0 and len(frontiers[2]) > 0):
    if(len(frontiers[0]) > 0 and (direction12 or direction13)): #
      nodeAPopped = heappop(frontiers[0])[1]
      if(prpNode12 != None and direction12):
        if(prpNode12 == nodeAPopped): # this equality is based on the states
          popNode12 = nodeAPopped
          result[0] = popNode12
          result[1] = prpNode12
          direction12 = False 
      if(prpNode13 != None and direction13):
        if(prpNode13 == nodeAPopped):
          popNode13 = nodeAPopped
          result[4] = popNode13
          result[5] = prpNode13
          direction13 = False

      explored[0].append(nodeAPopped)
      for edge in networkx.edges(graph, nodeAPopped.node['data'].id):
        childA = State(graph.node[edge[1]], nodeAPopped)
        if(childA not in explored[0]):
          altA = find_euclidean_dist(childA.parent.node, childA.node) + distances[0][childA.parent.node['data'].id]
          if(childA not in [x[1] for x in frontiers[0]]):
            heappush(frontiers[0], (altA, childA))
            distances[0][childA.node['data'].id] = altA
            heapify(frontiers[0])
          else:
            if(altA < distances[0][childA.node['data'].id]):
              indexA = frontiers[0].index((distances[0][childA.node['data'].id], childA))
              distances[0][childA.node['data'].id] = altA
              frontiers[0].pop(indexA)
              heapify(frontiers[0])
              heappush(frontiers[0], (altA, childA))
          num_explored = num_explored + 1
    else:
      nodeAPopped = None

    if(len(frontiers[1]) > 0 and (direction21 or direction23)):
      nodeBPopped = heappop(frontiers[1])[1]
      if(popNode12 != None and direction21):
        if(popNode12 == nodeBPopped):
          prpNode12 = nodeBPopped
          result[0] = popNode12
          result[1] = prpNode12
          direction21 = False
      if(prpNode23 != None and direction23):
        if(prpNode23 == nodeBPopped):
          popNode23 = nodeBPopped
          result[2] = popNode23
          result[3] = prpNode23
          direction23 = False
      explored[1].append(nodeBPopped)
      for edge in networkx.edges(graph, nodeBPopped.node['data'].id):
        childB = State(graph.node[edge[1]], nodeBPopped)
        if(childB not in explored[1]):
          altB = find_euclidean_dist(childB.parent.node, childB.node) + distances[1][childB.parent.node['data'].id]
          if(childB not in [x[1] for x in frontiers[1]]):
            heappush(frontiers[1], (altB, childB))
            distances[1][childB.node['data'].id] = altB
            heapify(frontiers[1])
          else:
            if(altB < distances[1][childB.node['data'].id]):
              indexB = frontiers[1].index((distances[1][childB.node['data'].id], childB))
              distances[1][childB.node['data'].id] = altB
              frontiers[1].pop(indexB)
              heapify(frontiers[1])
              heappush(frontiers[1], (altB, childB))
          num_explored = num_explored + 1
    else:
      nodeBPopped = None

    if(len(frontiers[2]) > 0 and (direction31 or direction32)):
      nodeCPopped = heappop(frontiers[2])[1]
      if(popNode13 != None and direction31):
        if(popNode13 == nodeCPopped):
          prpNode13 = nodeCPopped
          result[4] = popNode13
          result[5] = prpNode13
          direction31 = False
      if(popNode23 != None and direction32):
        if(popNode23 == nodeCPopped):
          prpNode23 = nodeCPopped
          result[2] = popNode23
          result[3] = prpNode23
          direction32 = False

      explored[2].append(nodeCPopped)
      for edge in networkx.edges(graph, nodeCPopped.node['data'].id):
        childC = State(graph.node[edge[1]], nodeCPopped)
        if(childC not in explored[2]):
          altC = find_euclidean_dist(childC.parent.node, childC.node) + distances[2][childC.parent.node['data'].id]
          if(childC not in [x[1] for x in frontiers[2]]):
            heappush(frontiers[2], (altC, childC))
            distances[2][childC.node['data'].id] = altC
            heapify(frontiers[2])
          else:
            if(altC < distances[2][childC.node['data'].id]):
              indexC = frontiers[2].index((distances[2][childC.node['data'].id], childC))
              distances[2][childC.node['data'].id] = altC
              frontiers[2].pop(indexC)
              heapify(frontiers[2])
              heappush(frontiers[2], (altC, childC))
          num_explored = num_explored + 1
    else:
      nodeCPopped = None
              
    if(direction12 == False and direction21 == False and direction23 == False and direction32 == False and direction13 == False and direction31 == False): # all frontiers have stopped   
        return result[0], result[1], result[2], result[3], result[4],result[5], distances[0][result[0].node['data'].id] + distances[1][result[1].node['data'].id], distances[1][result[2].node['data'].id] + distances[2][result[3].node['data'].id], distances[0][result[4].node['data'].id] + distances[2][result[5].node['data'].id], num_explored

    if(nodeAPopped != None and nodeBPopped != None):
      matchFound = False
      if(matchFound == False):
        for x in frontiers[0]: # forward search frontier. each x is a tuple
          if(x[1] == nodeBPopped):
            matchFound = True
            popNode12 = x[1]
            prpNode12 = nodeBPopped
            whichOptimal = 0 # second half is optimal
            direction21 = False
            direction12 = True
            break

      if(matchFound == False):
        for x in frontiers[1]: # backwards search frontier. each x is a tuple. x[1] is the state object
          if(x[1] == nodeAPopped):
            matchFound = True
            popNode12 = nodeAPopped
            prpNode12 = x[1]
            whichOptimal = 1 # first half is optimal
            direction21 = True
            direction12 = False
            break

      if(matchFound == False):
        if(nodeAPopped == nodeBPopped):
          matchFound = True
          popNode12 = nodeAPopped
          prpNode12 = nodeBPopped
          whichOptimal = 2  # total is optimal
          direction12 = False
          direction21 = False 



    if(nodeAPopped != None and nodeCPopped != None):
      matchFound = False
      if(matchFound == False):
        for x in frontiers[0]: # forward search frontier. each x is a tuple
          if(x[1] == nodeCPopped):
            matchFound = True
            popNode13 = x[1]
            prpNode13 = nodeCPopped
            whichOptimal = 0 # second half is optimal
            direction31 = False
            direction13 = True 
            break

      if(matchFound == False):
        for x in frontiers[2]: # backwards search frontier. each x is a tuple. x[1] is the state object
          if(x[1] == nodeAPopped):
            matchFound = True
            popNode13 = nodeAPopped
            prpNode13 = x[1]
            whichOptimal = 1 # first half is optimal
            direction31 = True
            direction13 = False
            break

      if(matchFound == False):
        if(nodeAPopped == nodeCPopped):
          matchFound = True
          popNode13 = nodeAPopped
          prpNode13 = nodeCPopped
          whichOptimal = 2  # total is optimal
          direction13 = False
          direction31 = False

    if(nodeBPopped != None and nodeCPopped != None):
      matchFound = False
      if(matchFound == False):
        for x in frontiers[1]: # forward search frontier. each x is a tuple
          if(x[1] == nodeCPopped):
            matchFound = True
            popNode23 = x[1]
            prpNode23 = nodeCPopped
            whichOptimal = 0 # second half is optimal
            direction32 = False
            direction23 = True 
            break

      if(matchFound == False):
        for x in frontiers[2]: # backwards search frontier. each x is a tuple. x[1] is the state object
          if(x[1] == nodeBPopped):
            matchFound = True
            popNode23 = nodeBPopped
            prpNode23 = x[1]
            whichOptimal = 1 # first half is optimal
            direction32 = True
            direction23 = False
            break

      if(matchFound == False):
        if(nodeBPopped == nodeCPopped):
          matchFound = True
          popNode23 = nodeBPopped
          prpNode23 = nodeCPopped
          whichOptimal = 2  # total is optimal
          direction23 = False
          direction32 = False


  print "No solution. frontiers ran out \n"
  return None, None, None, None, None, None, 0, 0, 0, num_explored  



def backtrack(state, graph):
    if state.parent != None:
        print "Node: ", state.node['data'].id
        if len(state.node['data'].tags) > 0:            
            for key in state.node['data'].tags.keys():
                print "       N: ", key, " ", state.node['data'].tags[key]        
              
        for edge in networkx.edges(graph, state.node['data'].id):
            if len(graph.node[edge[1]]['data'].tags) > 0:
                for key in graph.node[edge[1]]['data'].tags:
                    print "       E: ", graph.node[edge[1]]['data'].tags[key]
        backtrack(state.parent, graph)


"""
The setup
"""

print "\n\n----- 6601 Grad AI: Seaching ATLANTA ------\n\n"
only_roads = True
graph = read_osm('atlanta.osm', only_roads)

print "NUMBER OF NODES: ", len(graph.nodes())
print "NUMBER OF EDGES: ", len(graph.edges())

totalNodesUniformCost = 0
totalNodesBDS = 0
totalNodesTDS = 0
for x in range(1, 2):
  cityOneNum = random.randint(0, len(graph.nodes()))
  cityTwoNum = random.randint(0, len(graph.nodes()))
  cityThreeNum = random.randint(0, len(graph.nodes()))

  # select three cities randomly
  cityOne = graph.node[graph.nodes()[cityOneNum]]
  cityTwo = graph.node[graph.nodes()[cityTwoNum]]
  cityThree = graph.node[graph.nodes()[cityThreeNum]]

  print "City One         ", cityOne['data'].id
  print "City Two         ", cityTwo['data'].id
  print "City Three       ", cityThree['data'].id

  print "******RUNNING PAIRWISE UNIFORM COST SEARCH***************"
  stateA, costA, num_exploredA = uniform_cost_search(graph, State(cityOne, None), State(cityTwo, None))
  stateB, costB, num_exploredB = uniform_cost_search(graph, State(cityTwo, None), State(cityThree, None))
  stateC, costC, num_exploredC = uniform_cost_search(graph, State(cityThree, None), State(cityOne, None))

  totalNodesUniformCost += (num_exploredA+ num_exploredB+ num_exploredC)

  uniformCostStates =[stateA, stateB, stateC]
  uniformSearchCost = [costA+costB, costB+costC, costC+costA] # this will contain three combinations

  lowestIndexUCS = uniformSearchCost.index(min(uniformSearchCost))
  if(lowestIndexUCS == 0):
    print "Lowest path is the open path 1->2->3"
  elif(lowestIndexUCS == 1):
    print "Lowest Path is the open path 2->3->1"
  elif(lowestIndexUCS == 2):
    print "Lowest Path is the open path 3->1->2"

  print "Lowest path cost (UCS) is ", uniformSearchCost[lowestIndexUCS]
  print "Total nodes UCS    is", totalNodesUniformCost

  print "**********RUNNING PAIRWISE BDS (UCS VERSION)******************"
  fwdStateA, bwdStateA, bdsCostA, num_exploredBDSA = bidirectional_search(graph, State(cityOne, None), State(cityTwo, None))
  fwdStateB, bwdStateB, bdsCostB, num_exploredBDSB = bidirectional_search(graph, State(cityTwo, None), State(cityThree, None))
  fwdStateC, bwdStateC, bdsCostC, num_exploredBDSC = bidirectional_search(graph, State(cityThree, None), State(cityOne, None))

  totalNodesBDS += (num_exploredBDSA+ num_exploredBDSB + num_exploredBDSC)

  bdsStates = [(fwdStateA, bwdStateA), (fwdStateB, bwdStateB), (fwdStateC, bwdStateC)]
  bdsCost = [bdsCostA + bdsCostB, bdsCostB + bdsCostC, bdsCostC+bdsCostA]

  lowestIndexBDS = bdsCost.index(min(bdsCost))
  if(lowestIndexBDS == 0):
    print "Lowest path is the open path 1->2->3"
  elif(lowestIndexBDS == 1):
    print "Lowest Path is the open path 2->3->1"
  elif (lowestIndexBDS == 2):
    print "Lowest Path is the open path 3->1->2"

  print "Lowest path cost (BDS) is ", bdsCost[lowestIndexBDS]
  print "Total nodes BDS is ", totalNodesBDS


  print "**********RUNNING TDS******************"
  a,b,c,d,e,f,costAB, costBC, costCA, numExploredABC = tridirectional_search(graph, State(cityOne, None), State(cityTwo, None), State(cityThree, None))
  tdsCost = [costAB + costBC, costBC+costCA, costAB + costCA]
  totalNodesTDS += numExploredABC
  lowestIndexTDS = tdsCost.index(min(tdsCost))
  if(lowestIndexTDS == 0):
    print "Lowest path is the open path 1->2->3"
  elif(lowestIndexTDS == 1):
    print "Lowest Path is the open path 2->3->1"
  elif (lowestIndexTDS == 2):
    print "Lowest Path is the open path 3->1->2"

  print "Lowest path cost (TDS) is ", tdsCost[lowestIndexTDS]
  print "Total nodes TDS is ", totalNodesTDS



