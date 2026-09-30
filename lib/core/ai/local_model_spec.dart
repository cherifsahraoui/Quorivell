/// Short upstream license label for a recommended GGUF.
enum LocalModelLicenseKind { apache20, llama3Community, llama32Community }

/// On-device GGUF used for typed candidate extraction and chat.
class LocalModelSpec {
  const LocalModelSpec({
    required this.modelId,
    required this.fileName,
    required this.downloadUri,
    this.sha256,
    this.licenseKind = LocalModelLicenseKind.apache20,
    this.recommended = false,
    this.approximateBytes,
    this.needsMoreRam = false,
    this.uncensored = false,
    this.nCtx = 4096,
    this.nPredict = 768,
    this.nThreads = 4,
  });

  /// Qwen2.5-1.5B-Instruct Q4_K_M from the official Qwen GGUF repo.
  ///
  /// SHA-256 is the Hugging Face blob hash for
  /// `qwen2.5-1.5b-instruct-q4_k_m.gguf` on
  /// `Qwen/Qwen2.5-1.5B-Instruct-GGUF`.
  static const production = LocalModelSpec(
    modelId: 'Qwen2.5-1.5B-Instruct-Q4_K_M',
    fileName: 'Qwen2.5-1.5B-Instruct-Q4_K_M.gguf',
    downloadUri:
        'https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf',
    sha256: '6a1a2eb6d15622bf3c96857206351ba97e1af16c30d7a74ee38970e434e9407e',
    licenseKind: LocalModelLicenseKind.apache20,
    recommended: true,
    approximateBytes: 1120000000,
  );

  /// Qwen2.5-1.5B Instruct uncensored Q4_K_M (community GGUF of
  /// thirdeyeai/Qwen2.5-1.5B-Instruct-uncensored). Same size class as
  /// [production]; Apache-licensed base weights.
  static const qwen15InstructUncensoredQ4 = LocalModelSpec(
    modelId: 'Qwen2.5-1.5B-Instruct-uncensored-Q4_K_M',
    fileName: 'Qwen2.5-1.5B-Instruct-uncensored.Q4_K_M.gguf',
    downloadUri:
        'https://huggingface.co/mradermacher/Qwen2.5-1.5B-Instruct-uncensored-GGUF/resolve/main/Qwen2.5-1.5B-Instruct-uncensored.Q4_K_M.gguf',
    licenseKind: LocalModelLicenseKind.apache20,
    approximateBytes: 1117000000,
    uncensored: true,
  );

  /// Dolphin 3.0 Qwen2.5 1.5B Q4_K_M (community GGUF of
  /// dphn/Dolphin3.0-Qwen2.5-1.5B). Same size class as [production];
  /// Apache-licensed Qwen2.5 base, uncensored ChatML instruct tune.
  static const dolphin30Qwen15Q4 = LocalModelSpec(
    modelId: 'Dolphin3.0-Qwen2.5-1.5B-Q4_K_M',
    fileName: 'Dolphin3.0-Qwen2.5-1.5B.Q4_K_M.gguf',
    downloadUri:
        'https://huggingface.co/mradermacher/Dolphin3.0-Qwen2.5-1.5B-GGUF/resolve/main/Dolphin3.0-Qwen2.5-1.5B.Q4_K_M.gguf',
    licenseKind: LocalModelLicenseKind.apache20,
    approximateBytes: 986000000,
    uncensored: true,
  );

  /// Llama 3.2 3B Instruct Q4_K_M (community GGUF). Needs more RAM than Qwen 1.5B.
  static const llama32InstructQ4 = LocalModelSpec(
    modelId: 'Llama-3.2-3B-Instruct-Q4_K_M',
    fileName: 'Llama-3.2-3B-Instruct-Q4_K_M.gguf',
    downloadUri:
        'https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf',
    licenseKind: LocalModelLicenseKind.llama32Community,
    approximateBytes: 2020000000,
    needsMoreRam: true,
  );

  /// Llama 3.2 3B Instruct uncensored Q4_K_M (community GGUF).
  static const llama32InstructUncensoredQ4 = LocalModelSpec(
    modelId: 'Llama-3.2-3B-Instruct-uncensored-Q4_K_M',
    fileName: 'Llama-3.2-3B-Instruct-uncensored-Q4_K_M.gguf',
    downloadUri:
        'https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-uncensored-GGUF/resolve/main/Llama-3.2-3B-Instruct-uncensored-Q4_K_M.gguf',
    licenseKind: LocalModelLicenseKind.llama32Community,
    approximateBytes: 2240000000,
    needsMoreRam: true,
    uncensored: true,
  );

  /// Llama 3 8B Instruct Q4_K_M (community GGUF). Plan for several GB of RAM.
  static const llama3InstructQ4 = LocalModelSpec(
    modelId: 'Meta-Llama-3-8B-Instruct-Q4_K_M',
    fileName: 'Meta-Llama-3-8B-Instruct-Q4_K_M.gguf',
    downloadUri:
        'https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-Q4_K_M.gguf',
    licenseKind: LocalModelLicenseKind.llama3Community,
    approximateBytes: 4920000000,
    needsMoreRam: true,
  );

  /// In-app download menu. Qwen remains recommended; larger GGUFs need more RAM.
  static const catalog = [
    production,
    qwen15InstructUncensoredQ4,
    dolphin30Qwen15Q4,
    llama32InstructQ4,
    llama32InstructUncensoredQ4,
    llama3InstructQ4,
  ];

  static LocalModelSpec? byId(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final model in catalog) {
      if (model.modelId == id) return model;
    }
    return null;
  }

  final String modelId;
  final String fileName;
  final String downloadUri;

  /// Official digest for in-app downloads. Null means checksum is advisory only.
  final String? sha256;
  final LocalModelLicenseKind licenseKind;
  final bool recommended;
  final int? approximateBytes;
  final bool needsMoreRam;

  /// Community “uncensored” instruct GGUF with fewer refusal filters.
  final bool uncensored;
  final int nCtx;
  final int nPredict;
  final int nThreads;

  Uri get uri => Uri.parse(downloadUri);

  /// Hugging Face model page (not the resolve URL) for the info action.
  Uri get huggingFacePageUri {
    final parsed = Uri.parse(downloadUri);
    final segments = parsed.pathSegments;
    if (segments.length >= 2) {
      return Uri(
        scheme: parsed.scheme,
        host: parsed.host,
        pathSegments: segments.take(2),
      );
    }
    return parsed;
  }
}
