# Biometric Systems

File **evaluation.ipynb** evaluates a face recognition system using the Deepface framework in an open-set identification task. The evaluation focuses on detecting whether a user is registered in the system using performance metrics calculated on the Labeled Faces in the Wild (LFW) dataset.

## Abstract
The evaluation task is an open-set face recognition (1:N) scenario where unregistered users can interact with the system. The project leverages the **Deepface** framework and specifically uses the **GhostFaceNet** model, known for its high performance on the LFW dataset. The evaluation involves comparing all probe templates with all gallery templates, using a range of thresholds to assess the model's accuracy.

## Evaluation Metrics
The following metrics are computed to provide a comprehensive performance analysis of the face recognition system:
- **False Acceptance (FA) Rate**: Measures how often unauthorized users are incorrectly accepted.
- **False Rejection (FR) Rate**: Measures how often authorized users are incorrectly rejected.
- **Detection and Identification (DI) Rate**: Evaluates the system's ability to correctly detect and identify users.
- **Genuine Recognition (GR) Rate**: Assesses the overall accuracy in recognizing legitimate users.

Thresholds are varied from 0.01 to 0.99, with a step of 0.01, to generate detailed performance curves for these metrics.

## Dataset
The **Labeled Faces in the Wild (LFW)** dataset is used for evaluating the model. This dataset provides a benchmark for testing the accuracy of face recognition systems in unconstrained environments.

## Model Details
- **Framework**: Deepface
- **Model Used**: GhostFaceNet
- The model is chosen for its high recognition accuracy on the LFW benchmark.

## Evaluation Methodology
1. **Template Comparison**: All probe templates are compared with all gallery templates.
2. **Threshold Analysis**: The model's performance is evaluated across different thresholds to generate detailed statistics.
3. **Performance Metrics**: FA rate, FR rate, DI rate, and GR rate are calculated for each threshold to visualize the system's efficiency.

## Results
The evaluation results are visualized using various plots, including the DET curve, to analyze the trade-offs between different error rates.
