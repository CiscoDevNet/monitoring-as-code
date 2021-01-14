# AppDynamics extensions in Kubernetes environment

Using the Machine Agent, you can supplement the existing metrics in the AppDynamics Controller UI with your own custom metrics.

There are many extensions currently available on the [AppDynamics exchange](https://www.appdynamics.com/community/exchange/) community site. Some are created by AppDynamics and some have been created by users.

More about AppDynamics extensions can be found in the [documentation](https://docs.appdynamics.com/display/PRO45/Extensions+and+Custom+Metrics).

### Using Kubernetes extensions WithDependencies or WithoutDependencies?

Determine if extension is using external libraries and having dependencies. 

That can be usually done by checking requirements on AppDynamics exchange page, or inspecting the source code provided on AppDynamics GitHub repo for every extension. 

However, if you are still unsure which option to use after evaluating recommendations below, we recommend taking a conservative approach and following steps of deploying an extension `WithDependencies` option.

### 1) WithDependencies option

In case that the extension that you are planning to add to Kubernetes cluster is written in Bash, Shell, or Go, there are probably some dependencies that are required in order to run an extension - usually `jq` or `curl` packages.  
For those extensions, before moving source files to Kubernetes cluster, we'll have to install those packages so they are available in containerized environment, and for those follow the `WithDependencies` option.

Follow the steps inside `WithDependencies` folder of this repo.

### 2) WithoutDependencies option

In case that the extension that you are planning to add to Kubernetes cluster is written in some higher language like Java or C#, all necessary dependencies are contained in the .jar or .dll packages already, and you can follow the `WithoutDependencies` option.

Follow the steps inside `WithoutDependencies` folder of this repo.


