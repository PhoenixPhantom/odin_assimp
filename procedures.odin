//
//Based on "https://github.com/assimp/assimp/blob/master/include/assimp/cimport.h" (7.8.2024)
//
package assimp

import "core:c"
foreign import assimp "system:assimp"
//install assimp through your package manager: custom builds even with static linking don't really work for c (still require linking to -lstdc++ and -lm to compile and can still behave wierd then)

#assert(size_of(c.int) == size_of(b32))

LogStreamCallback :: #type proc(message: cstring, user: rawptr)
FileWriteProc :: #type proc(file: ^File, content: cstring, a, b: c.size_t) -> c.size_t
FileReadProc :: #type proc(file: ^File, content: [^]c.char, a, b: c.size_t) -> c.size_t
FileTellProc :: #type proc(file: ^File) -> c.size_t
FileFlushProc :: #type proc(file: ^File)
FileSeek :: #type proc(file: ^File, a: c.size_t, origin: Origin) -> Return //enum aiOrigin
FileOpenProc :: #type proc(fileIO: ^FileIO, a, b: cstring) -> ^File
FileCloseProc :: #type proc(fileIO: ^FileIO, file: ^File)

PrimitiveTypeForNIndices :: proc($n: int) -> PrimitiveTypeFlags {
	return n > 3 ? {.POLYGON} : {PrimitiveTypeFlag(n)}
}
GetMaterialFloat :: proc(
	#by_ptr mat: Material,
	key: cstring,
	type, index: c.uint,
) -> (
	val: c.float,
	ret: Return,
) {
	dummy: c.uint
	ret = GetMaterialFloatArray(mat, key, type, index, &val, &dummy)
	return val, ret
}


GetMaterialInteger :: proc(
	#by_ptr mat: Material,
	key: cstring,
	type, index: c.uint,
	out: ^c.int,
) -> (
	val: c.int,
	ret: Return,
) {
	dummy: c.uint
	ret = GetMaterialIntegerArray(mat, key, type, index, &val, &dummy)
	return val, ret
}

//conveniance functions

//Transform the assimp String to an odin string (points to the same data as the original (assimp) String)
//    allocates size_of(string) bytes
GetString :: proc(str: ^String) -> (string, bool) {
	if str.length <= 0 || str.length > MAXLEN do return {}, false
	return string(str.data[:str.length]), true
}

//Create an odin string based on the assimp String (copys all the string's contents)
//    allocates str.length + size_of(string) bytes
GetStringCopy :: proc(str: String) -> (string, bool) {
	if str.length <= 0 || str.length > MAXLEN do return {}, false
	str_copy := make([]byte, str.length)
	for i in 0 ..< str.length {
		str_copy[i] = str.data[i]
	}
	return string(str_copy[:]), true
}

@(default_calling_convention = "cdecl", link_prefix = "ai")
foreign assimp {
	/* --------------------------------------------------------------------------------
	   Reads the given file and returns its content.

      If the call succeeds, the imported data is returned in a Scene structure.
      The data is intended to be read-only, it stays property of the ASSIMP
      library and will be stable until ReleaseImport() is called. After you're
      done with it, call ReleaseImport() to free the resources associated with
      this file. If the import fails, nil is returned instead. Call
      GetErrorString() to retrieve a human-readable error text.

      @param file: Path and filename of the file to be imported,
         expected to be a cstring. nil is not a valid value.

      @param flags: Optional post processing steps to be executed after
         a successful import.

      @return Pointer to the imported data or nil if the import failed.
   */
	ImportFile :: proc(file: cstring, flags: PostProcessStepsFlags) -> ^Scene ---


	/* --------------------------------------------------------------------------------
	   Reads the given file using user-defined I/O functions and returns its content.
 
      If the call succeeds, the imported data is returned in a Scene structure.
      The data is intended to be read-only, it stays property of the ASSIMP
      library and will be stable until ReleaseImport() is called. After you're
      done with it, call ReleaseImport() to free the resources associated with
      this file. If the import fails, nil is returned instead. Call
      GetErrorString() to retrieve a human-readable error text.

      @param file: Path and filename of the file to be imported,
         expected to be a cstring. nil is not a valid value.

      @param flags: Optional post processing steps to be executed after
         a successful import.

      @param pFS: FileIO structure. Will be used to open the model file itself
         and any other files the loader needs to open.  Pass nil to use the default
         implementation.
      
      @return Pointer to the imported data or nil if the import failed.
   */
	ImportFileEx :: proc(file: cstring, flags: PostProcessStepsFlags, pFS: ^FileIO) -> ^Scene ---


	/* --------------------------------------------------------------------------------
	   Same as #ImportFileEx, but adds an extra parameter contning importer settings.
 
      @param file: Path and filename of the file to be imported,
         expected to be a cstring. nil is not a valid value.

     @param flags: Optional post processing steps to be executed after
         a successful import.

      @param pFS: FileIO structure. Will be used to open the model file itself
         and any other files the loader needs to open.  Pass nil to use the default
         implementation.

      @param pProps: #PropertyStore instance contning import settings.

      @return Pointer to the imported data or nil if the import failed.
   */
	ImportFileExWithProperties :: proc(file: cstring, flags: PostProcessStepsFlags, pFS: ^FileIO, pProps: ^PropertyStore) -> ^Scene ---

	ImportFileFromMemory :: proc(buffer: cstring, length: c.uint, flags: PostProcessStepsFlags, hint: cstring) -> ^Scene ---
	ImportFileFromMemoryWithProperties :: proc(buffer: cstring, length: c.uint, flags: PostProcessStepsFlags, hint: cstring, pProps: ^PropertyStore) -> ^Scene ---
	ApplyPostProcessing :: proc(pScene: ^Scene, flags: PostProcessStepsFlags) -> ^Scene ---
	GetPredefinedLogStream :: proc(stream: DefaultLogStream, file: cstring) -> LogStream ---
	AttachLogStream :: proc(pStream: ^DefaultLogStream) ---
	EnableVerboseLogging :: proc(d: b32) ---
	DetachLogStream :: proc(pStream: ^DefaultLogStream) -> Return ---
	DetachAllLogStreams :: proc() ---
	ReleaseImport :: proc(pScene: ^Scene) ---
	GetErrorString :: proc() -> cstring ---
	IsExtensionSupported :: proc(szExtension: cstring) -> b32 ---
	GetExtensionList :: proc(szOut: ^String) ---
	GetMemoryRequirements :: proc(input: Scene, info: ^MemoryInfo) ---
	CreatePropertyStore :: proc() -> ^PropertyStore ---
	ReleasePropertyStore :: proc(p: ^PropertyStore) ---

	SetImportPropertyInteger :: proc(store: ^PropertyStore, szName: cstring, value: c.int) ---
	SetImportPropertyFloat :: proc(store: ^PropertyStore, szName: cstring, value: real) ---
	SetImportPropertyString :: proc(store: ^PropertyStore, szName: cstring, st: ^String) ---
	SetImportPropertyMatrix :: proc(store: ^PropertyStore, szName: cstring, mat: ^Matrix4x4) ---


	GetImportFormatCount :: proc() -> c.size_t ---
	GetImporterDesc :: proc(extension: cstring) -> ^ImporterDesc ---
	GetImportFileFormatDescription :: proc(index: c.size_t) -> ^ImporterDesc ---

	TextureTypeToString :: proc(texType: TextureType) -> cstring ---
	GetMaterialProperty :: proc(#by_ptr mat: Material, key: cstring, type, index: c.uint, #by_ptr propOut: MaterialProperty) -> Return ---
	GetMaterialFloatArray :: proc(#by_ptr mat: Material, key: cstring, type, index: c.uint, out: [^]c.float, outLen: ^c.uint) -> Return ---
	GetMaterialIntegerArray :: proc(#by_ptr mat: Material, key: cstring, type, index: c.uint, out: [^]c.int, outLen: ^c.uint) -> Return ---
	GetMaterialColor :: proc(#by_ptr mat: Material, key: cstring, type, index: c.uint, out: ^Color4D) -> Return ---
	GetMaterialUVTransform :: proc(#by_ptr mat: Material, key: cstring, type, index: c.uint, out: ^UVTransform) -> Return ---
	GetMaterialString :: proc(#by_ptr mat: Material, key: cstring, type, index: c.uint, out: ^String) -> Return ---
	GetMaterialTextureCount :: proc(#by_ptr mat: Material, type: TextureType) -> c.uint ---


	GetExportFormatCount :: proc() -> c.size_t ---
	GetExportFormatDescription :: proc(index: c.size_t) -> ^ExportFormatDesc ---
	CopyScene :: proc(#by_ptr src: Scene, dst: ^^Scene) ---
	FreeScene :: proc(#by_ptr copy: Scene) --- //free the copy (created using CopyScene) of a scene
	ExportScene :: proc(#by_ptr scene: Scene, FormatId, FileName: cstring, Preprocessing: c.uint) -> Return ---
	ExportSceneEx :: proc(#by_ptr scene: Scene, FormatId, FileName: cstring, IO: ^FileIO, Preprocessing: c.uint) -> Return ---
	ExportSceneToBlob :: proc(#by_ptr scene: Scene, FormatId: cstring, Preprocessing: c.uint) -> ^ExportDataBlob ---
	ReleaseExportBlob :: proc(#by_ptr Data: ExportDataBlob) ---


	//for most cases: don't use these functions -> use the odin native types
	CreateQuaterinionFromMatrix :: proc(quat: ^Quaternion, mat: ^Matrix3x3) ---
	DecomposeMatrix :: proc(mat: ^Matrix4x4, scaling: ^Vector3D, rotation: ^Quaternion, position: ^Vector3D) ---
	TransposeMatrix4 :: proc(mat: ^Matrix4x4) ---
	TransposeMatrix3 :: proc(mat: ^Matrix3x3) ---
	TransformVecByMatrix3 :: proc(vec: ^Vector3D, #by_ptr mat: Matrix3x3) ---
	TransformVecByMatrix4 :: proc(vec: ^Vector3D, #by_ptr mat: Matrix4x4) ---
	MultiplyMatrix4 :: proc(left: ^Matrix4x4, #by_ptr right: Matrix4x4) ---
	MultiplyMatrix3 :: proc(left: ^Matrix3x3, #by_ptr right: Matrix3x3) ---
	IdentityMatrix4 :: proc(mat: ^Matrix4x4) ---
	IdentityMatrix3 :: proc(mat: ^Matrix3x3) ---

	Vector2AreEqual :: proc(#by_ptr a, b: Vector2D) -> b32 ---
	Vector2AreEqualEpsilon :: proc(#by_ptr a, b: Vector2D, epsilon: c.float) -> b32 ---
	Vector2Add :: proc(dst: ^Vector2D, #by_ptr add: Vector2D) ---
	Vector2Subtract :: proc(dst: ^Vector2D, #by_ptr subtr: Vector2D) ---
	Vector2Scale :: proc(dst: ^Vector2D, s: c.float) ---
	Vector2SymMul :: proc(dst: ^Vector2D, #by_ptr other: Vector2D) ---
	Vector2DivideByScalar :: proc(dst: ^Vector2D, s: c.float) ---
	Vector2DivideByVector :: proc(dst: ^Vector2D, v: ^Vector2D) --- //why the heck not const Vector2D* v
	Vector2Length :: proc(#by_ptr v: Vector2D) ---
	Vector2SquareLength :: proc(#by_ptr v: Vector2D) ---
	Vector2Negate :: proc(v: ^Vector2D) ---
	Vector2DotProduct :: proc(#by_ptr a, b: Vector2D) -> real ---
	Vector2Normalize :: proc(v: ^Vector2D) ---

	Vector3AreEqual :: proc(#by_ptr a, b: Vector3D) -> b32 ---
	Vector3AreEqualEpsilon :: proc(#by_ptr a, b: Vector3D, epsilon: c.float) -> b32 ---
	Vector3LessThan :: proc(#by_ptr a: Vector3D, #by_ptr b: Vector3D) -> b32 ---
	Vector3Add :: proc(dst: ^Vector3D, #by_ptr add: Vector3D) ---
	Vector3Subtract :: proc(dst: ^Vector3D, #by_ptr subtr: Vector3D) ---
	Vector3Scale :: proc(dst: ^Vector3D, s: c.float) ---
	Vector3SymMul :: proc(dst: ^Vector3D, #by_ptr other: Vector3D) ---
	Vector3DivideByScalar :: proc(dst: ^Vector3D, s: c.float) ---
	Vector3DivideByVector :: proc(dst: ^Vector3D, v: ^Vector3D) --- //why the heck not const Vector3D* v
	Vector3Length :: proc(#by_ptr v: Vector3D) ---
	Vector3SquareLength :: proc(#by_ptr v: Vector3D) ---
	Vector3Negate :: proc(v: ^Vector3D) ---
	Vector3DotProduct :: proc(#by_ptr a, b: Vector3D) -> real ---
	Vector3CrossProduct :: proc(dst: ^Vector3D, #by_ptr a, b: Vector3D) ---
	Vector3Normalize :: proc(v: ^Vector3D) ---
	Vector3NormalizeSafe :: proc(v: ^Vector3D) ---
	Vector3RotateByQuaternion :: proc(v: ^Vector3D, #by_ptr q: Quaternion) ---

	Matrix3FromMatrix4 :: proc(dst: ^Matrix3x3, #by_ptr mat: Matrix4x4) ---
	Matrix3FromQuaternion :: proc(dst: ^Matrix3x3, #by_ptr q: Quaternion) ---
	Matrix3AreEqual :: proc(#by_ptr a, b: Matrix3x3) -> b32 ---
	Matrix3AreEqualEpsilon :: proc(#by_ptr a, b: Matrix3x3, epsilon: c.float) -> b32 ---
	Matrix3Inverse :: proc(mat: ^Matrix3x3) ---
	Matrix3Determinant :: proc(mat: ^Matrix3x3) ---
	Matrix3RotationZ :: proc(mat: ^Matrix3x3, angle: c.float) ---
	Matrix3RotateFromAroundAxis :: proc(mat: ^Matrix3x3, #by_ptr axis: Vector3D, angle: c.float) ---
	Matrix3Translation :: proc(mat: ^Matrix3x3, #by_ptr translation: Vector2D) ---
	Matrix3FromTo :: proc(mat: ^Matrix3x3, #by_ptr from, to: Vector3D) ---

	Matrix4FromMatrix3 :: proc(dst: ^Matrix4x4, #by_ptr mat: Matrix3x3) ---
	Matrix4FromScalingQuaternionPosition :: proc(dst: ^Matrix4x4, #by_ptr scaling: Vector3D, #by_ptr rotation: Quaternion, #by_ptr position: Vector3D) ---
	Matrix4Add :: proc(dst: ^Matrix4x4, #by_ptr src: Matrix4x4) ---
	Matrix4AreEqual :: proc(#by_ptr a, b: Matrix4x4) -> b32 ---
	Matrix4AreEqualEpsilon :: proc(#by_ptr a, b: Matrix4x4, epsilon: c.float) -> b32 ---
	Matrix4Inverse :: proc(mat: ^Matrix4x4) ---
	Matrix4Determinant :: proc(#by_ptr mat: Matrix4x4) -> real ---
	Matrix4IsIdentity :: proc(#by_ptr mat: Matrix4x4) -> b32 ---
	Matrix4DecomposeIntoScalingEularAnglesPosition :: proc(#by_ptr mat: Matrix4x4, scaling: ^Vector3D, rotation: ^Vector3D, position: ^Vector3D) ---
	Matrix4DecomposeIntoScalingAxisAnglePosition :: proc(#by_ptr mat: Matrix4x4, scaling: ^Vector3D, axis: ^Vector3D, angle: ^real, position: ^Vector3D) ---
	Matrix4DecomposeNoScaling :: proc(#by_ptr mat: Matrix4x4, rotation: ^Vector3D, position: ^Vector3D) ---
	Matrix4FromEulerAngles :: proc(mat: ^Matrix4x4, x, y, z: c.float) ---
	Matrix4RoationX :: proc(mat: ^Matrix4x4, angle: c.float) ---
	Matrix4RoationY :: proc(mat: ^Matrix4x4, angle: c.float) ---
	Matrix4RoationZ :: proc(mat: ^Matrix4x4, angle: c.float) ---
	Matrix4FromRotationAroundAxis :: proc(mat: ^Matrix4x4, #by_ptr axis: Vector3D, angle: c.float) ---
	Matrix4Translation :: proc(mat: ^Matrix4x4, #by_ptr translation: Vector3D) ---
	Matrix4Scaling :: proc(mat: ^Matrix4x4, #by_ptr scaling: Vector3D) ---
	Matrix4FromTo :: proc(mat: ^Matrix4x4, #by_ptr from, to: Vector3D) ---

	QuaternionFromEulerAngles :: proc(q: ^Quaternion, x, y, z: c.float) ---
	QuaternionFromAxisAngle :: proc(q: ^Quaternion, #by_ptr axis: Vector3D, angle: c.float) ---
	QuaternionFromNormalizedQuaternion :: proc(q: ^Quaternion, #by_ptr normalized: Vector3D) ---
	QuaternionAreEqual :: proc(#by_ptr a, b: Quaternion) -> b32 ---
	QuaternionAreEqualEpsilon :: proc(#by_ptr a, b: Quaternion, epsilon: c.float) -> b32 ---
	QuaternionNormalize :: proc(q: ^Quaternion) ---
	QuaternionConjugate :: proc(q: ^Quaternion) ---
	QuaternionMultiply :: proc(left: ^Quaternion, #by_ptr right: Quaternion) ---
	QuaternionInterpolate :: proc(dst: ^Quaternion, #by_ptr start, end: Quaternion, factor: c.float) ---
}
