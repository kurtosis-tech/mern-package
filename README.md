# MERN package

This is a [Kurtosis](https://github.com/kurtosis-tech/kurtosis/) MERN package you can use as a template to create your own MERN project.

## How to run this MERN example package?

### Step 1

Create the package's configuration file to set your custom values to run the package.

Duplicate the `example-config.yml` file and rename it to `config.yml`.

```bash
# in the package's root
cp ./example-config.yml ./config.yml
```

Fill the created `config.yml` file with your custom values.

Make sure to not commit or include this file in the repository history (for serurity reasons dude it contains private credentials), you can check that the `config.yml` was added into the `.gitignore` file.

### Step 2

If you have [Kurtosis installed][install-kurtosis], run:

```bash
kurtosis run github.com/kurtosis-tech/mern-package --args-file config.yml
```

If you don't have Kurtosis installed, [click here to run this package on the Kurtosis cloud](https://cloud.kurtosis.com/).

To blow away the created [enclave][enclaves-reference], run `kurtosis clean -a`.

### Step 3

You can access to the application in the browser by clicking or copying the `react-frontend` address printed at the end of the package execution, in the `Ports` colum inside the `User Services` section
<img alt="frontend address example" src="./readme-files/frontend-address.png" />

## How to create your own MERN application based on this package?

### STEP 1

Click ["Use this template"](https://github.com/benelferink/MERN-template/generate) to generate a new repository.
Then open your terminal and clone your repository:

```bash
# replace YOURUSER and YOURREPO with the correct values
cd ~/Desktop
git clone https://github.com/[YOURUSER]/[YOURREPO].git
```

### STEP 2

#### Create your own backend service

You can edit the Express backend service by editing the files inside the `./backend/files` folder.

#### Create your own frontend service

You can edit the React frontend service by editing the files inside the `./frontend/files` folder.

<!-------------------------------- LINKS ------------------------------->
[install-kurtosis]: https://docs.kurtosis.com/install
[enclaves-reference]: https://docs.kurtosis.com/concepts-reference/enclaves
