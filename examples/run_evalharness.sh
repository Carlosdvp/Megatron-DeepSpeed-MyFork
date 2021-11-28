#!/bin/bash

# Example file to run the evaluation harness.
# 

export HF_DATASETS_CACHE=$SCRATCH/cache/


CHECKPOINT_PATH=checkpoints/gpt2
#_pipeline
VOCAB_FILE=gpt2-vocab.json
MERGE_FILE=gpt2-merges.txt
DATA_PATH=my-gpt2_text_document

GPT_ARGS=" \
    --num-layers 12 \
    --hidden-size 1024 \
    --num-attention-heads 16 \
    --seq-length 1024 \
    --max-position-embeddings 1024 \
    --micro-batch-size 4 \
    --global-batch-size 8 \
    --lr 0.00015 \
    --train-iters 500000 \
    --lr-decay-iters 320000 \
    --lr-decay-style cosine \
    --vocab-file $VOCAB_FILE \
    --merge-file $MERGE_FILE \
    --lr-warmup-fraction .01 \
    --fp16 \
    --pipeline-model-parallel-size 2\
    --tensor-model-parallel-size 1\
    "


DATA_ARGS=" \
    --load $CHECKPOINT_PATH \
    --tokenizer-type GPT2BPETokenizer
    "
#    --load $CHECKPOINT_PATH \



CMD="./tasks/eval_harness/evaluate.py $GPT_ARGS $DATA_ARGS"
N_GPUS=1
LAUNCHER="deepspeed --num_gpus $N_GPUS"

$LAUNCHER $CMD

"""
python -m torch.distributed.launch $DISTRIBUTED_ARGS ./tasks/eval_harness/evaluate.py \
               --task_list piqa,boolq,wikitext \
               --tokenizer-type GPT2BPETokenizer \
               --vocab-file $VOCAB_FILE \
               --merge-file $MERGE_FILE \
               --load $CHECKPOINT \
               --tensor-model-parallel-size 1 \
               --pipeline-model-parallel-size 1 \
               --num-layers 12 \
               --hidden-size 1024 \
               --num-attention-heads 16 \
               --micro-batch-size 1 \
               --checkpoint-activations \
               --seq-length 1024 \
               --max-position-embeddings 1024 \
               --log-interval 10 \
               --fp16 \
               --no-load-optim \
               --no-load-rng
"""