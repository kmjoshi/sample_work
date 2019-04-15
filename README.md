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
- I learnt how to:
	- do unit testing
	- about different design patterns
	- that there is [no silver bullet](http://faculty.salisbury.edu/~xswang/Research/Papers/SERelated/no-silver-bullet.pdf)
	- Exposure to Java
	- that Android Studio is a hassle
### [CS 6601: Artificial Intelligence](https://in.udacity.com/course/artificial-intelligence--ud954)
- Great class! Great text: [AI: A Modern Approach](http://aima.cs.berkeley.edu/)
- minimax | markov chain modeling | game theory | rational agent
### [CS 7641: Machine Learning](https://www.omscs.gatech.edu/cs-7641-machine-learning)
- Great hilarious instructors
- theoretical ML
	- hypothesis space
	- power of random forests
	- ICA vs PCA
		- orthogonal components vs. components that explain variance
### CS 7642: Reinforcement Learning
- RL theory | rational agent
- simplicity of bellman eqns.
- game theory
### CS 8803: Graduate Algorithms
### CS 7646: Machine Learning for Trading
### [CS 6460: Educational Technology](http://omscs6460.gatech.edu/)
- [Physics-js](https://github.com/kmjoshi/physics-js): interactive website to teach physics (under construction)
- Exposure to:
	- the field of EdTech
	- the great work being done by other students and practitioners
	- as well as very cool ideas like constructionism that are behind products like Scratch
### CS 6035: Intro to Information Security
- web hacks are cool: XSS | XSRF | SQL injection
	- PHP is bad?!
- stack overflow!
### CS 6250: Computer Networks
- Can computer networking theory/protocols be applied to social networks? Are they?
- TCP vs. UDP
### [CSE 6242: Data and Visual Analytics](https://poloclub.github.io/cse6242-2018fall-online/)

- [Google Trends Symptom Clusters](https://kmjoshi.github.io/disease_trends/) : Visualising clusters of medical symptoms searched in Google over time and at state-level, alongside their pair-correlations as a network/graph 
- Exposure to: AWS | Hadoop | Spark | Scala etc.
- Azure ML studio is a great GUI for ML pipelines