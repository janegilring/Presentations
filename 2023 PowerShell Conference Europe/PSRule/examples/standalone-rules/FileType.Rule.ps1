# Synopsis: Image files are not permitted.
Rule 'PS.FileType' -Type 'System.IO.FileInfo' {
    $Assert.NotIn($TargetObject, 'Extension', @('.jpg', '.png'))
}