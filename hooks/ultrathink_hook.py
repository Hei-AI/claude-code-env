#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json

data = {
    "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalContext": "ultrathink"
    }
}

print(json.dumps(data, indent=2, ensure_ascii=False))