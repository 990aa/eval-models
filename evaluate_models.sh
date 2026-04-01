#!/bin/bash

# Define paths relative to your root directory
LLAMA_CLI="./llama.cpp/build/bin/llama-cli"
MODEL_DIR="./llama.cpp/models"
OUTPUT_FILE="evaluation_results.txt"

# Define the model filenames
MODELS=(
    "Qwen3.5-0.8B.Q5_K_M.gguf"
    "Qwen3.5-2B.Q5_K_M.gguf"
    "Qwen3.5-4B.Q4_K_M.gguf"
)

# Define the 5 evaluation prompts
PROMPTS=(
    "Evaluate the integral \int_{0}^{\infty} \frac{\sin(x)}{x} dx using contour integration. Walk me through the choice of the contour, the handling of the pole at the origin, and the application of Cauchy's Integral Theorem or the Residue Theorem. Be rigorous with the limits as the contour radii approach zero and infinity."
    "Provide a formal, step-by-step mathematical proof demonstrating that every finite integral domain is a field. State any underlying definitions or lemmas clearly before applying them to your final conclusion."
    "Write a thread-safe, lock-free concurrent queue in Rust using atomic operations. I do not want a standard Mutex-based solution. Implement the push and pop methods. Most importantly, provide a detailed explanation of the memory ordering guarantees (e.g., Acquire, Release, SeqCst) you selected for your atomic operations and why they are strictly necessary to prevent race conditions in this specific data structure."
    "Implement a custom, minimal Autograd (automatic differentiation) engine in Python completely from scratch without using PyTorch, TensorFlow, or NumPy. It must support scalar addition, multiplication, and the ReLU activation function. Include the backward pass logic (topological sort) to compute gradients. Finally, demonstrate its use by building and running a single forward and backward pass for a simple 2-layer multi-layer perceptron."
    "Assume a database schema with Employees(emp_id, manager_id, salary) and Departments(dept_id, dept_name, emp_id). Write an advanced SQL query using recursive Common Table Expressions (CTEs) to find the maximum depth of the management chain for every single department, and identify the specific employee at the very bottom of that deepest chain. Write this query assuming OracleDB syntax and explain the recursive logic step-by-step."
)

# Titles for the output file formatting
PROMPT_NAMES=(
    "1. Advanced Mathematics - Contour Integration"
    "2. Abstract Algebra Proof"
    "3. Systems Programming (Rust)"
    "4. Algorithmic Machine Learning (Python)"
    "5. Advanced Database Querying (SQL)"
)

# Initialize the master output file
echo "==================================================" > "$OUTPUT_FILE"
echo "          LLM EVALUATION RESULTS REPORT           " >> "$OUTPUT_FILE"
echo "==================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Loop through each model
for model in "${MODELS[@]}"; do
    echo "=================================================="
    echo ">> Loading model: $model"
    echo "=================================================="
    
    # Loop through each prompt for the current model
    for i in "${!PROMPTS[@]}"; do
        prompt_name="${PROMPT_NAMES[$i]}"
        prompt_text="${PROMPTS[$i]}"
        
        echo " -> Running: $prompt_name"
        
        # Write clear headers to the text file so you know what you're looking at
        echo "##################################################" >> "$OUTPUT_FILE"
        echo "MODEL:  $model" >> "$OUTPUT_FILE"
        echo "PROMPT: $prompt_name" >> "$OUTPUT_FILE"
        echo "##################################################" >> "$OUTPUT_FILE"
        
        # Execute llama-cli. We redirect stderr (2>&1) so you get the generation tokens/sec stats logged too!
        $LLAMA_CLI -m "$MODEL_DIR/$model" -c 2048 -n 1024 --temp 0.3 -p "$prompt_text" >> "$OUTPUT_FILE" 2>&1
        
        # Add some breathing room between outputs
        echo -e "\n\n\n" >> "$OUTPUT_FILE"
    done
done

echo "=================================================="
echo "EVALUATION COMPLETE! All results saved to: $OUTPUT_FILE"
echo "=================================================="