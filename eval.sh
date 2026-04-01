#!/bin/bash

# =========================================================================
# THE "BRUTE FORCE" TERMINAL CAPTURE WRAPPER
# If the script isn't running inside our capture tool, relaunch it inside 'script'.
# This creates a fake terminal, forcing llama-cli to write its text to the file.
# =========================================================================
if [ "$1" != "--captured" ]; then
    export NO_COLOR=1 # Disable color codes to keep the text file clean
    echo "Initializing Terminal Capture..."
    > evaluation_results.txt # Clear the file
    
    # 'script' records absolutely everything on the screen to the file
    script -q -e -c "$0 --captured" evaluation_results.txt
    
    echo "=================================================="
    echo "EVALUATION COMPLETE! All raw output saved to: evaluation_results.txt"
    echo "=================================================="
    exit 0
fi

# =========================================================================
# ACTUAL EVALUATION SCRIPT (Runs inside the captured terminal)
# =========================================================================
LLAMA_CLI="./llama.cpp/build/bin/llama-cli"
MODEL_DIR="./llama.cpp/models"

MODELS=(
    "Qwen3.5-0.8B.Q5_K_M.gguf"
    "Qwen3.5-2B.Q5_K_M.gguf"
    "Qwen3.5-4B.Q4_K_M.gguf"
)

PROMPTS=(
    "Evaluate the integral \int_{0}^{\infty} \frac{\sin(x)}{x} dx using contour integration. Walk me through the choice of the contour, the handling of the pole at the origin, and the application of Cauchy's Integral Theorem or the Residue Theorem. Be rigorous with the limits as the contour radii approach zero and infinity."
    "Provide a formal, step-by-step mathematical proof demonstrating that every finite integral domain is a field. State any underlying definitions or lemmas clearly before applying them to your final conclusion."
    "Write a thread-safe, lock-free concurrent queue in Rust using atomic operations. I do not want a standard Mutex-based solution. Implement the push and pop methods. Most importantly, provide a detailed explanation of the memory ordering guarantees (e.g., Acquire, Release, SeqCst) you selected for your atomic operations and why they are strictly necessary to prevent race conditions in this specific data structure."
    "Implement a custom, minimal Autograd (automatic differentiation) engine in Python completely from scratch without using PyTorch, TensorFlow, or NumPy. It must support scalar addition, multiplication, and the ReLU activation function. Include the backward pass logic (topological sort) to compute gradients. Finally, demonstrate its use by building and running a single forward and backward pass for a simple 2-layer multi-layer perceptron."
    "Assume a database schema with Employees(emp_id, manager_id, salary) and Departments(dept_id, dept_name, emp_id). Write an advanced SQL query using recursive Common Table Expressions (CTEs) to find the maximum depth of the management chain for every single department, and identify the specific employee at the very bottom of that deepest chain. Write this query assuming OracleDB syntax and explain the recursive logic step-by-step."
)

PROMPT_NAMES=(
    "1. Advanced Mathematics - Contour Integration"
    "2. Abstract Algebra Proof"
    "3. Systems Programming (Rust)"
    "4. Algorithmic Machine Learning (Python)"
    "5. Advanced Database Querying (SQL)"
)

echo "=================================================="
echo "          LLM EVALUATION RESULTS REPORT           "
echo "=================================================="
echo ""

for model in "${MODELS[@]}"; do
    echo "=================================================="
    echo ">> Evaluating model: $model"
    echo "=================================================="
    
    for i in "${!PROMPTS[@]}"; do
        prompt_name="${PROMPT_NAMES[$i]}"
        prompt_text="${PROMPTS[$i]}"
        
        echo " -> Running: $prompt_name"
        echo "##################################################"
        echo "MODEL:  $model"
        echo "PROMPT: $prompt_name"
        echo "##################################################"
        
        # We removed the '>>' redirection here. 
        # We let it print directly to the screen, and our 'script' wrapper catches it all.
        $LLAMA_CLI -m "$MODEL_DIR/$model" -c 2048 -n 1024 --temp 0.3 -p "$prompt_text" --single-turn --log-disable
        
        echo -e "\n\n\n"
    done
done