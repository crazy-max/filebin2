{{ define "apispec" }}openapi: '3.0.0'
info:
  version: 2.0.0
  title: filebin
  description: Filebin is a file sharing service that aims to be convenient and easy to use.
  termsOfService: /terms
paths:
  '/{bin}/{filename}':
    get:
      tags:
        - file
      summary: Download a file from a bin
      description: This is a regular file download, which includes content-length and checksums of the content in the response headers. The content-type will be set according to the content.
      parameters:
        - name: bin
          in: path
          description: The bin to download from.
          required: true
          schema:
            type: string
        - name: filename
          in: path
          description: The filename of the file to download from the bin specified.
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful download.
        '403':
          description: The file download count limitation was reached.
          content:
            application/json: {}
        '404':
          description: The file was not found. The bin may be expired, the file is deleted or it did never exist in the first place.
          content:
            application/json: {}
    delete:
      tags:
        - file
      summary: Delete a file from a bin
      description: This will delete a file from a bin. Everyone knowing the URL to the bin have access to deleting files from it.
      parameters:
        - name: bin
          in: path
          description: The bin to delete from.
          required: true
          schema:
            type: string
        - name: filename
          in: path
          description: The filename of the file to delete.
          required: true
          schema:
            type: string
      responses:
        '200':
          description: The file was successfully flagged for deletion.
          content:
            application/json: {}
        '404':
          description: The file was not found. The bin may be expired or it did never exist in the first place.
          content:
            application/json: {}
    post:
      tags:
        - file
      summary: Upload a file to a bin
      description: Upload a file to a new or existing bin. The bin will be created if it does not exist prior to the upload.
      requestBody:
        content:
          application/octet-stream:
            schema:
              type: string
      parameters:
        - in: header
          name: cid
          description: A custom id of the client uploading
          required: false
          schema:
            type: string
      responses:
        '201':
          description: Successful upload.
          content:
            application/json: {}
        '400':
          description: Invalid input, typically invalid bin or filename specified.
          content:
            application/json: {}
        '403':
          description: The storage limitation was reached.
          content:
            application/json: {}
        '405':
          description: The bin is locked and can not be written to
          content:
            application/json: {}
  /:
    post:
      tags:
        - file
      summary: Upload a file to a bin (Deprecated)
      description: This is kept to achieve backwards compatibility with a redirect.
      parameters:
        - in: header
          name: bin
          description: The bin to upload the file to
          required: true
          schema:
            type: string
        - in: header
          name: filename
          description: The filename of the file to upload
          required: true
          schema:
            type: string
      requestBody:
        content:
          application/octet-stream:
            schema:
              type: string
      responses:
        '307':
          description: Redirect to the new location
          content:
            application/json: {}
  '/{bin}':
    get:
      tags:
        - bin
      summary: Show a bin
      description: This will show meta data about the bin such as timestamps, file sizes, file names and so on.
      parameters:
        - name: bin
          in: path
          description: The bin to show.
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful operation
          content:
            application/json: {}
        '404':
          description: The bin does not exist or is not available
          content:
            application/json: {}
    put:
      tags:
        - bin
      summary: Lock an entire bin to make it read only
      description: This will make a bin read only. A read only bin does not accept new files to be uploaded or existing files to be updated. This provides some content integrity when distributing a bin to multiple parties. Note that it is possible to delete a read only bin.
      parameters:
        - name: bin
          in: path
          description: The bin to lock.
          required: true
          type: string
      responses:
        '200':
          description: Successful operation
          content:
            application/json: {}
        '404':
          description: The bin does not exist or is not available
          content:
            application/json: {}
    delete:
      tags:
        - bin
      summary: Delete an entire bin and all of its files
      description: This will delete all files from a bin. It is not possible to reuse a bin that has been deleted. Everyone knowing the URL to the bin have access to delete it.
      parameters:
        - name: bin
          in: path
          description: The bin to delete.
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful operation
          content:
            application/json: {}
        '404':
          description: The bin does not exist or is not available
          content:
            application/json: {}
  '/qr/{bin}':
    get:
      tags:
        - bin
      summary: Generate a QR code with the absolute URL to the bin
      description: This will generate a PNG image with a QR code that has embedded the absolute URL to the bin. This makes it convenient to share the bin across mobile devices.
      parameters:
        - name: bin
          in: path
          description: The bin to embed in the QR code
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful operation
          content:
            image/png: {}
  '/archive/{bin}/tar':
    get:
      tags:
        - bin
      summary: Get all the files in the bin in a tar archive
      description: This will tar archive the files on the fly and deliver a response with chunked transfer encoding since the final size is not known.
      parameters:
        - name: bin
          in: path
          description: The bin to get.
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful operation
        '404':
          description: The bin does not exist or is not available
          content:
            application/json: {}
  '/archive/{bin}/zip':
    get:
      tags:
        - bin
      summary: Get all the files in the bin in a zip compressed file
      description: This will zip compress the files on the fly and deliver a response with chunked transfer encoding since the final size is not known.
      parameters:
        - name: bin
          in: path
          description: The bin to get.
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful operation
        '404':
          description: The bin does not exist or is not available
          content:
            application/json: {}
{{ end }}
