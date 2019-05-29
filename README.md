Here are listed my general thoughts on work I have done in my life.

## Ocean Modelling Research @ Georgia Tech | LANL
The bulk of the following research was motivated by probing to what extent higher resolution models of the ocean capture dynamics missed by lower resolution models (resolution here refers to spatial resolution of models, size of an individual grid-cell. Global climate models use ~50km, regional models like [ECMWF](https://www.ecmwf.int/) use ~10km). We probed the submesoscale ~1km-5km in regional ocean simulations using [ROMS-AGRIF](http://www.croco-ocean.org/documentation/ROMS_AGRIF-User-Guide/).

[Presentation](./ocean_modeling/Lagrangian_presentation.pdf)(for videos/gifs go [here](./ocean_modeling/README.md)) and [Report](./ocean_modeling/lagrangian_report.pdf) on the effect of model resolution, seasonality on lagrangian trajectories launched in the South Atlantic

[Presentation](./ocean_modeling/GOM15_keshav.pdf) at Gulf of Mexico Oil Spill & Ecosystem Science Conference on the effects of spatial resolution on tracer evolution and dynamics

[Paper](./ocean_modeling/bracco2016.pdf) published in Ocean Modeling on submesoscale phenomena

2 cents: There are submesoscale structures that are missed by lower resolution models which affect the local transport of particles, but parametrizations (which are basically hacks to efficiently mimic high-resolution models) such as [KPP](https://journals.ametsoc.org/doi/abs/10.1175/1520-0485(1999)029%3C0449%3AVOVMIA%3E2.0.CO%3B2) effectively capture aggregate dynamics. Nonetheless there is always need to better study submesoscale dynamics to keep improving the parametrizations as we get access to more powerful compute.

## Lecturing @ University of Guyana

I taught the following courses:
- Fundamentals of Physics + Lab. Using the classic book: [Fundamentals of Physics](https://books.google.co.in/books?hl=en&lr=&id=HybkAwAAQBAJ&oi=fnd&pg=PR34&dq=fundamentals+of+physics&ots=TshfyhMI4D&sig=wfRDECNhOInjapqI3qYoX7ZgmMI#v=onepage&q=fundamentals%20of%20physics&f=false)
- Sampling Methodology. Using [Lohr](https://books.google.co.in/books?id=-p6RDwAAQBAJ&dq=lohr+sampling+design+and+analysis&source=gbs_navlinks_s), [Schaeffer](https://books.google.co.in/books?id=TbSjtoy4p-8C&dq=elementary+survey+sampling&source=gbs_navlinks_s) and these [course notes](https://pdfs.semanticscholar.org/33d7/8e9baf07b73dadf16a75d94974ad9f57b585.pdf)
- Mechanics. Using [Serway](https://books.google.co.in/books?id=VUUvBwAAQBAJ&dq=serway+physics+for+scientists+and+engineers&source=gbs_navlinks_s), [Morin](https://books.google.co.in/books?id=Ni6CD7K2X4MC&dq=morin&source=gbs_navlinks_s), [hyperphysics](http://hyperphysics.phy-astr.gsu.edu/hbase/hframe.html), and the timeless [Feynman lectures](http://www.feynmanlectures.caltech.edu/I_toc.html)
- Introduction to Nuclear Physics and Heat. Using [Serway](https://books.google.co.in/books?id=Yfo3rnt3bkEC&dq=serway+modern+physics&source=gbs_navlinks_s) and [Young](https://books.google.co.in/books?id=o4KUlwEACAAJ&dq=young+modern+physics+13th&hl=en&sa=X&ved=0ahUKEwiTqdTOtdHhAhW67XMBHe2KCKwQ6AEIODAC)

Note: I'm happy to share my syllabus/assignments/tests if you are teaching a course

### Math-Physics-Stats Club
Of all the sesssions students loved [Non-newtonian fluids](https://www.youtube.com/watch?v=NPrCuIgX2_I) demonstration the most, and mostly punching multi-colored corn-starch as opposed to learning about all [Non-Newtonian fluids](https://en.wikipedia.org/wiki/Non-Newtonian_fluid#/media/File:Rheology_of_time_independent_fluids.svg)

[List of resources](https://docs.google.com/document/d/1krllrQxnC8VQY3NAupyENBjjj59B5CCBG7Ci2qqgSMg/edit?usp=sharing) shared with students. A slightly different version of the same [here](https://kmjoshi.github.io/physics-js/iwanttolearnmore.html)

[Talk](./Joshi_TechEdTalk_UG.pdf) on ML/AI and its many uses in the modern world, basic introduction, and how AI is not an existential threat (see [video](https://www.youtube.com/watch?v=_wwUJfJJyHA&t=1315s), which does not show the slides but instead only goes to prove that I am not an AI!)

## OMSCS @ Georgia Tech

### [CS 6300: Software Development Process](https://in.udacity.com/course/software-development-process--ud805)
- I learnt:
	- how-to unit testing (JUnit)
	- to build an Android app (Basic calculator and Tournament Manager)
	- about different life-cycle models (waterfall, spiral, evolutionary prototyping, rational unified process and agile)
	- about different design patterns (factory method, strategy, visitor, decorator, iterator, observer, proxy	)
	- that there is [no silver bullet](http://faculty.salisbury.edu/~xswang/Research/Papers/SERelated/no-silver-bullet.pdf)
### [CS 6601: Artificial Intelligence](https://in.udacity.com/course/artificial-intelligence--ud954)
- Great class! Great text: [AI: A Modern Approach](http://aima.cs.berkeley.edu/)
- I learnt to:
	- design minimax/alpha-beta game agents
	- implement/test classical search algorithms such as A*
	- implement/test Bayesian inference algorithms
	- implement/test Decision trees/Random forests
	- implement/test KMeans/Gaussian Mixture Models for image compression
	- implement/test Hidden Markov Models for identifying Morse Code sequences
### [CS 7641: Machine Learning](https://www.omscs.gatech.edu/cs-7641-machine-learning)
- Great hilarious instructors!
- Exploring KNN, SVM, Neural Networks, pruned decision trees and AdaBoost Random Forests on two classification problems from [UCI repository](http://archive.ics.uci.edu/ml/datasets.php):
	- prediction of eye-state from [EEG data](http://archive.ics.uci.edu/ml/datasets/EEG+Database)
	- prediction of signal/background from [Cherenkov telescope data](http://archive.ics.uci.edu/ml/datasets/MAGIC+Gamma+Telescope)
- Exploring optimization problems using [ABAGAIL](https://github.com/pushkar/ABAGAIL). Problems such as:
	- NN weight optimization
	- Traveling Salesman
	- Flip flop
	- Four peaks  
using algirithms such as: Randomized Hill Climbing, Simulated Annealing, Genetic Algorithms and MIMIC
- Exploring clustering and dimensional reduction on the two datasets mentioned earlier
	- K-Means and GMM clustering
	- PCA and ICA dimensional reduction
	- Randomnized projections and feature agglomeration
	- NNs were retrained with additional cluster information and separately on dimensionally-reduced dataset to mixed results, but no significant improvements for these datasets
- Exploring Markov Decision Processes
	- Exploring Policy Iteration/Value Iteration/Q-learning to solve two MDPS:
		- Small stochastic MDP (20 states, 2 actions)
		- Large deterministic MDP (400 states, 4 actions)
- Exposure to ML concepts such as:
	- How to learn: inductive reasoning: Occam's razor pick the simplest most accurate hypothesis. Simple will likely generalize better. There is some tradeoff across the two parameters simplicity and accuracy (also known as time + storage/param space complexity)
		- There is a tradeoff between the expressiveness of a hypothesis space (as in VC dimension) and the complexity of finding a good hypothesis in that space (Russell, Norvig pg. 697) 
		- A turing machine might be the most expressive hypothesis space but impossible to learn/ guarantee a finite turing machine
	- maximum likelihood hypothesis
		- ![hml](http://www.sciweavers.org/tex2img.php?eq=h_{ml}=argmax_{h%20\epsilon%20H}P(data|H)P(h)&bc=White&fc=Black&im=jpg&fs=12)
		- H is the hypothesis space for that problem statement
		- P(h) is prior distribution of that hypothesis (like a decision tree or 3-degree polynomial or three layer NN)
		- Overfitting grows with the size of the hypothesis space and number of attributes
		decreases with the number of training examples
	- NO FREE LUNCH (like no silver bullet)
	- Bayesian inference
	- Randomized optimization
	- Kullblack-Leibler divergence | Mutual Information
	- ICA vs PCA
		- orthogonal components vs. components that explain variance
	- YOU MUST EARN YOUR COMPLEXITY
	- Model-based vs. Model-free reinforcement learning
	- Nash equilibria | multi-agent general-sum game theory

### CS 7642: Reinforcement Learning
- Determining optimal policy for stochastic games
- Implementing Time-difference (TD) learning, model-free
- Exploring when Policy Iteration fails
- Implementing Q-learning
- _Exploring_ k-armed bandits problem
- Exploring [KWIK learners](http://icml2008.cs.helsinki.fi/papers/627.pdf)
- Implementation of [Sutton's classic paper on TD learning](http://incompleteideas.net/papers/sutton-88-with-erratum.pdf)
- Navigating a lunar lander to its pad using Deep-Q-Learning in [OpenAI environment](https://gym.openai.com/envs/LunarLander-v2/)
	- [Deep learning](https://www.nature.com/articles/nature14236) is used to approximate the optimal Q-values based on an exploration-exploitation strategy of the environment
- Implementation of [Correlated-Q-Learning](https://www.aaai.org/Papers/ICML/2003/ICML03-034.pdf)
- Exposure to RL concepts such as:
	- finite horizon problem
	- reward shaping
	- exploration vs exploitation (a dilemma for the ages)
	- Environments can be:
		- deterministic vs. stochastic environments
		- fully observable vs. partially observable
			- POMDPs are most real-world problems
	- multi-agent game theory
### CS 8803: Graduate Algorithms
Explored concepts such as:
- Big O complexity
Explored Problem Domains:
- Memoization | Hash-tables
- Dynamic Programming
	- define subproblem in words: acting on a prefix/substring
	- strengthen the subproblem
	- define a recurrence relation: 1D/2D/ND tables
- Divide and Conquer | Recursion
	- break problems into subproblems that are the same type of problem
	- obtain [recursion relation](https://en.wikipedia.org/wiki/Master_theorem_(analysis_of_algorithms)) in the form: T(n) <= a * T(n/b) + c * n
		- a = b: O(n log n)
		- a < b: O(n)
		- a > b: O(n^log_b(a)) 
	- ex. [FFT](https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm)
- Graph Algorithms
	- BFS | DFS | Djikstra | Bellman-Ford
	- Undirected graphs | Directed Acyclic Graphs (DAG) | Strongly Connected Components (SCC)
		- a DAG has no SCCs
	- Satisfiability Problem (SAT)
		- formula f in CNF (conjuctive normal form, literals with and/or)
		- assign boolean values to each literal such that f=True
	- Minimum Spanning Tree (MST)
		- Kruskal's algorithm
		- Prim's algorithm
	- PageRank
- Max-Flow
	- Problem:
		- given: directed G(V,E); with edge capacities c(e) > 0; with s,t in V
			- s: source, t: target
		- goal: find max flow f(e) through network (s->t)
			- maximize f(s) = f(into t)
		- capacity constraint: for all e in E: 0 <= f(e) <= c(e)
		- conservation of flow: for all v in V - {s, t}: (flow into v) = (flow out of v)
	- Ford-Fulkerson Algorithm
	- Edmonds-Karp Algorithm
	- Max-flow = Min-cut
		- Cut across graph that minimizes the total flow over each cut edge, is equivalent to the max-flow
- Linear Programming: optimization of a system of linear inequalities
	- Standard form:
		- max cT * x &nbsp; | &nbsp; A * x <= b &nbsp; | &nbsp; x >= 0
		- c: (n,1), x: (n,1), b: (m,1), A: (m,n)
		- n variables | m inequality constraints | n + m constraints
		- has an equivalent dual LP, which is a minimization problem
	- LP problems:
		- max-flow | min-cut
		- bipartite matching
		- zero-sum games
- NP-completeness
	- P: set of all problems solvable in polynomial time
		- 2-SAT
		- MST
		- Shortest path
		- bipartite matching
		- LP
	- NP: set of problems, whose solutions can be verified in polynomial time
	- NP-complete: set of problems in NP, every problem in NP can be [mapped/reduced](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDH2v2kCVDPuDQ4jUy05BEdUTQSZ7Zq9bjaX3Vm3HNokCwJdY5BQ) to this problem in polynomial time
		- SAT
		- ILP
		- Max-flow = Min-cut
		- Independent Set
		- Vertex Cover
		- Clique
		- Longest path
		- Knapsack search
	- NP-hard: solution cannot be verified in polynomial time
		- MAX-SAT
		- TSP
		- Factoring
![P!=NP](https://upload.wikimedia.org/wikipedia/commons/a/a0/P_np_np-complete_np-hard.svg)
- Randomized Algorithms
	- RSA
	- Bloom filters
### CS 7646: Machine Learning for Trading
- Forecasting concepts: 
	- Bollinger bands: moving averages as indicators of future stock movement
	- Sharpe Ratio: measure of risk adjusted average daily return from a portfolio
	- ML for stock forecasting
		- use backtesting and roll-forward cross-validation
	- implemented 
		- decision trees
		- bagging
		- Q-learner
		- manual indicator + rule-based strategy
		- market simulator  
		to optimize trading of single stock in the past
- [Market](https://www.tradingview.com/chart/?symbol=SP%3ASPX) concepts:	
	- Types of funds:
		- Exchange-Traded-Funds (ETFs): transparent | liquid
		- Mutual Funds: less transparent | diversified
		- Hedge Funds: not transparent | risky
	- Cramer: cyclical vs. secular stocks
	- Value: 
		- intrinsic value: dividends
		- book value: assets - liabilities
	- Capital Assets Pricing Model (CAPM)
		- return(t) = beta*return_of_market(t) + alpha(t)
		- E(alpha) = 0
			- market always wins
		- buying beta: looking for returns based on market growth
		- buying alpha: looking for returns based on investment skill
	- [indicators](https://stockcharts.com/school/doku.php?id=chart_school:technical_indicators)
	- Efficient Markets Hypothesis (EMH): cannot beat the market
		- information is readily used and prices adapt
		- types of information: price/volume, fundamental, exogenous, insider
- Monty Python jokes
### [CS 6460: Educational Technology](http://omscs6460.gatech.edu/)
- [Physics-js](https://github.com/kmjoshi/physics-js): interactive website to teach physics (under construction)
- Exposure to:
	- the field of EdTech
	- the great work being done by other students and practitioners
	- as well as very cool ideas like constructionism that are behind products like Scratch
### CS 6035: Intro to Information Security
- Explored concepts such as: 
	- objectives of security
		- confidentiality
		- integrity
		- availability
	- terminology:
		- threat actors exploit vulnerabilities to launch attacks
		- attacks lead to compromises/breaches
		- vulnerabilities can be found in software, networks and humans
	- Buffer overflow, stack overflow, how memory is structured to prevent this
		- stack canaries, adress space layout randomization (ASLR), non-executable stack, strongly typed languages and runtime checks
	- Authentication, access control, mandatory access control (MAC)
	- Types of malware: viruses, worms, botnets
	- Firewalls
	- Intrusion detection
	- Types of encryption: 
		- symmetric: traffic | authentication
			- DES, AES
		- asymmetric: authentication | key exchange | digital signatures
	- Types of cryptography:
		- secret-key
		- public key
			- RSA, Diffie-Hellman key exchange
	- Hashes: SHA, HMAC
	- Security Protocols
	- IPSec, TLS
		- handshake protocol
- Assignments:
	- Understanding stack, heap overflows and return-to-libc attacks
	- Malware analysis using [Cuckoo](https://cuckoosandbox.org/)
	- Explored [Broadcasting RSA attack](https://en.wikipedia.org/wiki/Coppersmith%27s_attack)
	- Implementing in PHP
		- XSS: Cross-site scripting
		- XSRF: Cross-site request forgery
		- SQL injection: " 'or 1 = 1 --"
### CS 6250: Computer Networks
- Assignments:
	- Using [mininet](http://mininet.org/) to simulate different real network topologies
		- implemented [spanning tree protocol](https://en.wikipedia.org/wiki/Spanning_Tree_Protocol)
		- implemented distributed Bellman-Ford algorithm based distance-vector routing protocols
		- implemented BGP prefix-hijacking attack
	- Analyse the impact of [TCP Fast Open](https://en.wikipedia.org/wiki/TCP_Fast_Open) on page load times 
		- analyse TCP CUBIC and TCP Reno to understand different congestion control algorithms
	- Used SDN ([Pyretic](https://github.com/frenetic-lang/pyretic)) to write simple firewall rules 
- Can computer networking theory/protocols be applied to social networks? Are they?
- External [notes](https://www.omscs-notes.com/computer-networks/welcome) for insight into the content
### [CSE 6242: Data and Visual Analytics](https://poloclub.github.io/cse6242-2018fall-online/)
- Big data engineering:
	- Exposure to sqlite, [OpenRefine](http://openrefine.org/) for cleaning text-data
	- Exposure to hadoop, aws (EC2, S3), azure, pig, spark/scala (databricks)
	- implemented basic model on Azure ML studio
- Visualizations:
	- Graph/network visualizations using [Gephi](https://gephi.org/)
	- Tableau
	- d3.js: line-charts, bar-charts, scatter-plots, choropleths, networks, heatmaps, with hover/dropdown interactivity
- Implemented decision trees, random forests
	- compare RFs, SVMs and NNs on data
- [Google Trends Symptom Clusters](https://kmjoshi.github.io/disease_trends/) : Visualising clusters of medical symptoms searched in Google over time and at state-level, alongside their pair-correlations as a network/graph 