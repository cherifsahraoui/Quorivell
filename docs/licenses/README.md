# Catalog model licenses

Quorivell’s in-app model screen offers the GGUFs in
`LocalModelSpec.catalog` (`lib/core/ai/local_model_spec.dart`). Quorivell
**does not redistribute model weights** in this repository. Users download or
import a GGUF on device. Each file stays under its **upstream** license;
Quorivell grants no extra rights.

User-selected GGUFs outside the catalog are the user’s responsibility.

| Catalog model | Short label (in-app) | Notice |
| --- | --- | --- |
| Qwen2.5-1.5B-Instruct-Q4_K_M (recommended) | Apache-2.0 | [QWEN_NOTICE.md](QWEN_NOTICE.md) |
| Qwen2.5-1.5B-Instruct-uncensored-Q4_K_M | Apache-2.0 | [QWEN_NOTICE.md](QWEN_NOTICE.md) (same Qwen Apache base) |
| Dolphin3.0-Qwen2.5-1.5B-Q4_K_M | Apache-2.0 | [DOLPHIN_QWEN_NOTICE.md](DOLPHIN_QWEN_NOTICE.md) |
| Llama-3.2-3B-Instruct-Q4_K_M | Llama 3.2 Community | [LLAMA32_NOTICE.md](LLAMA32_NOTICE.md) |
| Llama-3.2-3B-Instruct-uncensored-Q4_K_M | Llama 3.2 Community | [LLAMA32_NOTICE.md](LLAMA32_NOTICE.md) |
| Meta-Llama-3-8B-Instruct-Q4_K_M | Llama 3 Community | [LLAMA3_NOTICE.md](LLAMA3_NOTICE.md) |

Community GGUF hosts (e.g. bartowski, mradermacher) package upstream weights;
they do not replace Meta / Qwen / Dolphin license terms.
