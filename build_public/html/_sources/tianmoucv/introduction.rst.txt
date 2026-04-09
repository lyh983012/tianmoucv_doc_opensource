TianMouCV 算法库
===============
TianMouCV是一个专门为Tianmouc传感器（混合时空差分-帧的互补视觉传感器）设计的高性能计算机视觉库。
它结合了传统基于帧（Frame-based）的视觉算法和新兴的基于时空差分数据（TSD-based）的视觉处理技术
旨在提供高动态范围（HDR）、高帧率重建，支持低延迟追踪、检测、交互和稳健的光流估计等功能。

目前文档基于 Tianmoucv-0.4.2.0 版本

.. contents:: 目录
   :depth: 2
   :local:

安装指南
------------------------------

Unix 系统安装
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. 安装基本的编译工具：

.. code-block:: bash

    sudo apt-get update
    sudo apt-get install make cmake build-essential
    
*注：macOS 使用 brew 安装 gcc/g++，install 默认使用 g++。*

.. code-block:: bash

    brew install make cmake gcc

2. 安装 Python 和 PyTorch（推荐使用 CUDA 版本与 Anaconda）：

.. code-block:: bash

    conda create -n tianmoucv --python=3.10
    conda activate tianmoucv
    conda install pytorch torchvision torchaudio pytorch-cuda=12.0 -c pytorch -c nvidia

3. 执行自动安装脚本：

.. code-block:: bash

    pip install tianmoucv -i https://pypi.tuna.tsinghua.edu.cn/simple

或者从源码安装：

.. code-block:: bash

    git clone https://github.com/Tianmouc/tianmoucv.git
    cd tianmoucv
    sh install.sh

Windows 系统安装
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. 安装基本的编译工具（MinGW, Make, CMake, Git）：

- `MinGW-w64 <https://www.mingw-w64.org/>`_ (建议下载最新预编译版本)
- `CMake <https://cmake.org/download/>`_
- `Make for Windows <https://gnuwin32.sourceforge.net/packages/make.htm>`_
- `Git for Windows <https://git-scm.com/download/win>`_

*注意：将 MinGW 的 bin 文件夹路径添加到系统环境变量 PATH 中。*

2. 安装 Python 和 PyTorch：

.. code-block:: bash

    conda create -n tianmoucv --python=3.10
    conda activate tianmoucv
    conda install pytorch torchvision torchaudio pytorch-cuda=12.0 -c pytorch -c nvidia

3. 执行自动安装脚本：

.. code-block:: bash

    git clone git@github.com:Tianmouc/tianmoucv.git
    cd tianmoucv
    ./install.bat

软件包结构与功能概览
------------------------------

TianMouCV 核心包分为以下几个主要模块：

- **tianmoucv.camera**: 相机 SDK 与实时流接口，支持多目相机同时使用及自动曝光控制。
- **tianmoucv.data**: 灵活的数据读取器，支持多种格式（.tmdat, PCIe 二进制数据）和数据集管理。
- **tianmoucv.isp**: 图像信号处理，包含 RAW 到 RGB 处理、高动态范围（HDR）融合、去马赛克及可视化工具。
- **tianmoucv.proc**: 核心算法库，分为特征提取、光流估计、图像重建和目标追踪等子模块。
- **tianmoucv.sim**: 传感器软件仿真器，能够模拟真实硬件的 2x2 ROD 分簇结构、多种噪声模型（泊松噪声、读出噪声、固定模式噪声等）以及稀疏编码逻辑。
- **tianmoucv.rdp**: 数据解码与协议处理模块。

数据格式说明 (TMDAT)
------------------------------

TMDAT 是 Tianmouc 传感器记录数据的标准格式。一个典型的数据集结构如下：

.. code-block:: text

    ├── dataset_root/
    │   ├── sample_name (matchkey)/
    │   │   ├── cone/
    │   │       ├── info.txt
    │   │       ├── xxx.tmdat  (存储 RGB/RAW 数据，低帧率)
    │   │   ├── rod/
    │   │       ├── info.txt
    │   │       ├── xxx.tmdat  (存储 TD, SDL, SDR 数据，高帧率)

- **CONE (RGB)**: 对应低帧率高分辨率的图像流（30.3 fps）。
- **ROD (TSD)**: 对应高帧率（最高 10000 fps）的差分数据流。
- **matchkey**: 数据集索引中的唯一标识。

调用示例说明
------------------------------

在 ``tianmoucv_example`` 目录下提供了丰富的示例程序，涵盖了从基础控制到高级算法的应用：

基础控制与数据处理
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- **相机操作**: ``camera/open_camera.py`` (开启相机流), ``camera/TMC_GUI_controller.py`` (图形界面控制器)。
- **数据管理**: ``introduction_to_tianmouc_data.ipynb`` (详细讲解 TMDAT 格式与读取方式)。
- **格式转换**: ``data/convert_pcie_bin_to_tmdat.py`` (将 PCIe 二进制数据转换为标准 TMDAT 格式)。

传感器仿真 (Simulator)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- **仿真器分析**: ``simulator/Tianmouc_Simulator_Analysis.md`` (详细的传感器建模分析报告)。
- **交互式仿真**: ``simulator/sim.ipynb`` (展示如何将普通视频序列转换为仿真 Tianmouc 数据流)。

核心算法应用 (Proc)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- **光流估计 (Optical Flow)**: 
    - ``proc/optical_flow/opticalflow_HS_method.ipynb`` (传统 Horn-Schunck 方法)。
    - ``proc/optical_flow/opticalflow_LK_method.ipynb`` (传统 Lucas-Kanade 方法)。
    - ``proc/optical_flow/opticalflow_spynet.ipynb`` (深度学习 SpyNet 模型)。
- **图像重建 (Reconstruction)**: 
    - ``proc/reconstructor/reconstruct_gray.ipynb`` (基础灰度重建)。
    - ``proc/reconstructor/reconstruct_tiny_unet.ipynb`` (轻量级 UNet 重建)。
    - ``proc/reconstructor/SLIM/`` (自监督运动图像学习算法实现)。
- **目标追踪 (Tracking)**: 
    - ``proc/feature_tracking_sd.ipynb`` (基于 SD 数据的特征点提取与追踪)。
- **图像增强**: 
    - ``proc/denoise/denoise_tmdat_lvatf.ipynb`` (低照度降噪算法)。
    - ``proc/deblur/deblur_stgdnet.ipynb`` (基于时空梯度的去模糊算法)。

API 接口详细说明
------------------------------

.. _index_camera:

相机接口 (tianmoucv.camera)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
主要提供相机连接、流媒体读取和自动曝光等功能。

.. automodule:: tianmoucv.camera.sdk_utils
   :members:
   :no-index:

.. _index_data:

数据读取 (tianmoucv.data)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
支持从本地存储读取 Tianmouc 原始数据并进行预处理。

.. automodule:: tianmoucv.data.tianmoucData
   :members:
   :no-index:

.. _index_isp:

图像处理 (tianmoucv.isp)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
提供 RAW 图像到 RGB 图像的转换，以及差分数据的可视化。

.. automodule:: tianmoucv.isp.isp_basic
   :members:
   :no-index:

.. _index_sim:

传感器仿真器 (tianmoucv.sim)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
模拟传感器硬件逻辑，生成合成数据。

- **run_sim**: 高级接口，处理图像序列文件夹，输出完整的数据集结构。
- **run_sim_singleimg**: 简单接口，处理单张图像，输出仿真的差分张量。

.. automodule:: tianmoucv.sim.simple_tmc_sim_advance
   :members:
   :no-index:

.. _index_proc:

算法库 (tianmoucv.proc)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

特征库 (features)
"""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: tianmoucv.proc.features.diff
   :members:
   :no-index:

光流算法 (opticalflow)
"""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: tianmoucv.proc.opticalflow.estimator
   :members:
   :no-index:

重建算法 (reconstruct)
"""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: tianmoucv.proc.reconstruct.basic
   :members:
   :no-index:

目标追踪 (tracking)
"""""""""""""""""""""""""""""""""""""""""""""
.. automodule:: tianmoucv.proc.tracking.feature_tracker
   :members:
   :no-index:

详细示例索引
------------------------------

.. toctree::
    :maxdepth: 1

    /tianmoucv/feature_matching/feature_matching
    /tianmoucv/feature_tracking_tested/feature_tracking_tested
    /tianmoucv/opticalflow_HS_method/opticalflow_HS_method
    /tianmoucv/opticalflow_LK_method/opticalflow_LK_method
    /tianmoucv/opticalflow_SPYNET/opticalflow_SPYNET
    /tianmoucv/reconstruct_gray/reconstruct_gray
    /tianmoucv/reconstruct_hdr_Laplacian/reconstruct_hdr_Laplacian
    /tianmoucv/reconstruct_tiny_unet/reconstruct_tiny_unet
