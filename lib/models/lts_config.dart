class LTSConfig {
  String? region;
  String? projectId;
  String? groupId;
  String? streamId;
  String? accessKey;
  String? secretKey;

  LTSConfig(
      {this.region,
      this.projectId,
      this.groupId,
      this.streamId,
      this.accessKey,
      this.secretKey});

  Map<String, dynamic> toJson() => {
        "region": region,
        "projectId": projectId,
        "groupId": groupId,
        "streamId": streamId,
        "accessKey": accessKey,
        "secretKey": secretKey,
      };
}
